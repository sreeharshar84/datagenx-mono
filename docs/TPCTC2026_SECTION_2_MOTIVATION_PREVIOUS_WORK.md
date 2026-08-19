# 2. Motivation and Previous Work

This section positions the present work as an extension of DataGenX V1. The
earlier paper introduced annotated SQL DDL as a practical interface for
generating relational synthetic data from schema-level specifications. This
paper addresses the next problem: how to remove most of the manual annotation
work by deriving generation rules from an existing schema and optimizer-visible
statistics, and how to validate that the resulting synthetic database preserves
the behavior that matters for query optimization. The novelty is therefore not
synthetic data generation in isolation, but the automation and validation path
from relational catalog metadata and optimizer statistics to a privacy-preserving
synthetic database whose optimizer-facing behavior can be checked through
statistics and query plans.

## 2.1 Motivation

Database developers, benchmark authors, and query optimizer engineers often need
representative data long before they can access production data. This need has
been recognized repeatedly in benchmark and data-generation work, including the
Parallel Data Generation Framework (PDGF), BigBench, and work on skew-aware
benchmark generation [RablJacobsen2014, GhazalEtAl2013, RablEtAl2013SSB].
In many enterprise settings, the available inputs are not raw rows, but database
metadata: table definitions, primary and foreign keys, table cardinalities,
column distinct counts, index metadata, top values, and histograms collected by
the optimizer. This is a common and useful boundary. The schema captures the
shape of the application, while optimizer statistics summarize the distributions
that drive plan selection. At the same time, this boundary avoids direct access
to sensitive customer data.

This setting is especially important for reproducing query optimization and
performance issues. A query plan is rarely determined by schema alone. Cost-based
optimizers depend on row counts, predicate selectivities, join cardinalities,
data skew, key distributions, and date or numeric ranges. Rabl et al.'s work on
SSB skew variations makes this point directly: benchmarks intended to exercise
optimizer behavior must expose richer data distribution details, including
non-uniform distributions and sparsity, because those details affect plan choice
[RablEtAl2013SSB]. If a synthetic dataset
matches only table names and column types, it may be useful for functional
testing, but it is often inadequate for plan reproduction. Conversely, copying
real data may preserve plans, but it is frequently impossible because of privacy,
compliance, contractual, or operational constraints.

DataGenX V1 addressed this problem by allowing users to encode generation logic
directly in SQL DDL annotations. This made it possible to describe row counts,
column distributions, top values, histogram buckets, and parent-child
relationships in a declarative and scalable way. The V1 evaluation showed that
annotated DDL can reproduce benchmark-like datasets with high fidelity while
remaining independent of real source rows.

However, the V1 workflow still placed a significant burden on the user. Someone
had to inspect the schema, understand the workload, study the relevant
statistics, write annotations, encode relationships between tables, handle key
and foreign-key constraints, and then validate that the generated data matched
the intended statistical profile. This manual process is manageable for a small
schema or a carefully designed benchmark, but it becomes tedious and fragile for
larger schemas with many tables, composite keys, low-cardinality columns,
skewed categorical values, and optimizer histograms.

In practice, we observed several recurring problems with manual annotation:

- Users tend to preserve table cardinalities but miss optimizer-relevant column
  distributions, especially low-cardinality categorical columns and date ranges.
- Foreign-key columns are easy to generate syntactically but difficult to
  generate with the same frequency distribution and join behavior as the source.
- Composite primary-key and foreign-key relationships require coordinated value
  generation across multiple columns; treating each column independently can
  create invalid or statistically distorted data.
- Random weighted generation can match a distribution only approximately, and
  small benchmark scale factors can expose bucket drift because some intended
  values are missed entirely.
- Validation is often scattered across ad hoc scripts, making it unclear whether
  failures come from row counts, referential integrity, histogram drift, distinct
  counts, or query-plan differences.
- Query-level testing is complicated when the synthetic dataset intentionally
  changes literal values. A source query such as a TPC-H predicate over
  `l_shipmode = 'MAIL'` must be translated to the corresponding synthetic
  literal before comparing target-side plans.

These issues motivate automation around DataGenX rather than a replacement for
it. The goal is to keep the V1 insight, namely that annotated DDL is a compact
and scalable representation for synthetic data generation, but to derive those
annotations automatically from the source database metadata and optimizer
statistics. The generated synthetic database should preserve the statistical
signals used by the optimizer while avoiding direct reuse of source values.

The extension presented in this paper focuses on this automation and validation
layer. Given a source schema and optimizer statistics, it generates DataGenX
templates, produces a synthetic target schema, loads the generated data, creates
optimizer histograms on the target, and validates the result using a unified
validation workflow. The validation compares table cardinalities, referential
integrity, distinct counts where appropriate, histogram distribution shapes, and
query-plan behavior. For query validation, the system can render TPC-H query
templates, construct a local source-to-synthetic literal mapping, rewrite
target-side predicates, and compare source and target execution plans.

This workflow is useful because it turns information that database systems
already maintain for their optimizers into an executable data-generation
specification. The source database contributes schema definitions, key
relationships, table cardinalities, column distinct counts, and histogram
metadata; DataGenX converts those signals into generation rules; and the
validation layer checks whether the synthetic target preserves the optimizer
signals after loading. This closes a practical gap between static benchmark
generators, which are reproducible but fixed, and data-driven synthesis tools,
which can be flexible but often require access to real rows.

A key design requirement is that distribution preservation must not imply value
preservation. For histograms, the validation compares bucket probability masses
and bucket counts rather than requiring the same endpoint values or string
literals. For example, a source distribution over values `N`, `R`, and `A` can
match a target distribution over synthetic values `1`, `2`, and `3` if the
frequency shape is the same. This distinction is essential: the purpose is to
reproduce optimizer-visible behavior, not to leak source domain values.

## 2.2 Previous Work

Synthetic data generation has been studied from several directions, including
benchmark-specific generators, machine-learning-based synthesis, declarative
constraint-based tools, and statistics-driven systems. These approaches provide
different tradeoffs among fidelity, flexibility, privacy, scalability, and ease of
use.

Benchmark generators such as TPC-H, TPC-DS, and TPC-C remain the most widely
used tools for database benchmarking. They provide carefully designed schemas,
scalable data generation, and reproducible workloads. Their strength is also
their limitation: the schemas, distributions, and generation rules are
benchmark-specific. They are excellent for comparing systems under a standard
workload, but they do not directly help when the task is to reproduce a
customer-like schema, a workload-specific optimizer issue, or a modified schema
with different statistics. Variants such as the Star Schema Benchmark and
schema-focused benchmark generators explore related design points. The skew-aware
SSB work by Rabl et al. is particularly relevant because it argues that uniform
benchmark distributions are insufficient for testing modern optimizers and shows
how PDGF can be used to generate both data and query sets with controlled
non-uniformity [RablEtAl2013SSB]. Earlier work on introducing skew into TPC-H
made a similar point for decision-support benchmarks: realistic non-uniformity is
important for testing optimizer robustness [GhazalCrolotte2011]. These efforts
motivate the same broad goal as DataGenX, but they still operate at the level of
benchmark-specific extensions rather than automatically deriving generation
rules from an arbitrary source schema and its optimizer statistics.

The PDGF line of work is also central to this space. Rabl and Jacobsen present
PDGF as a generic data generator for big-data benchmark pipelines, emphasizing
parallel data generation and the need to cover end-to-end data processing rather
than isolated execution stages [RablJacobsen2014]. Rabl et al. later introduce
meta-generators in PDGF to reduce the effort of developing customized data
generators and to make generator debugging and maintenance easier
[RablEtAl2013PDGF]. This is close in spirit to DataGenX's goal of reducing the
manual burden of generator construction. The difference is the interface and
input assumption: DataGenX uses SQL DDL plus optimizer-visible statistics as the
specification boundary, and this extension automates the construction of those
generation rules from a live relational catalog.

BigBench and its later implementation work further highlight the importance of
synthetic generation for realistic, end-to-end analytics benchmarks. BigBench
proposed a retail-oriented benchmark with structured, semi-structured, and
unstructured data, including a synthetic data generator intended to address
volume, velocity, and variety [GhazalEtAl2013]. Rabl et al.'s complete BigBench
implementation refined the dataset, scaling, refresh process, and metric for the
Hadoop ecosystem [RablEtAl2015BigBench]. These works show how much benchmark
value comes from pairing a realistic workload model with a scalable data
generator. DataGenX takes a complementary path: instead of defining one standard
business model, it aims to synthesize data for arbitrary schemas using the
statistics already available in the database system.

Machine-learning-based approaches, including tabular synthesis systems such as
SDV and commercial tools such as Tonic.ai, learn statistical patterns from real
datasets and then generate synthetic rows with similar properties. These systems
can be powerful when representative data is available for training. However,
that assumption is often incompatible with the target use case of this paper:
early-stage development, customer issue reproduction, or privacy-sensitive
debugging where raw data cannot be shared. ML-based synthesis may also focus on
row-level resemblance or analytical utility rather than the specific metadata
signals used by a relational query optimizer, such as histograms, key
cardinalities, and plan stability.

Declarative and constraint-oriented systems such as DataSynth, XData, and QAGen
focus on generating data that satisfies constraints or exercises particular
queries. This line of work is valuable for testing query correctness and
constraint satisfaction. However, such tools often require specialized inputs,
query-specific formulations, or solving techniques that can become difficult to
scale and operate as a general-purpose workflow over arbitrary production-like
schemas. They also do not typically provide an end-to-end bridge from optimizer
statistics to scalable data generation and query-plan validation.

Other systems focus on scaling or transforming existing data. Dscaler, for
example, scales empirical relational datasets while preserving selected
properties. High-throughput synthesis engines have also been proposed for
stress-testing large systems. These systems emphasize volume, performance, or
controlled scaling, but they generally assume either an existing dataset or a
specific generation model. Rabl et al.'s SIGMOD demonstration, "Just can't get
enough: Synthesizing Big Data," is an important point in this design space: it
targets automatic synthesis from existing data sources and emphasizes the
practical difficulty that real customer data is often unavailable because of
privacy regulations [RablEtAl2015Synth]. Myriad similarly targets parallel data
generation for shared-nothing systems while preserving cross-partition
dependencies, correlations, and distributions [AlexandrovEtAl2011]. These
systems reinforce the need for scalable and realistic generation, but they do
not directly address the common case where
the available input is schema plus optimizer statistics, but no source rows.

DataGenX V1 filled an important gap by introducing a schema-driven,
annotation-based generator. It showed that annotated SQL DDL can express column
distributions, top values, histograms, row-level expressions, and inter-table
relationships while scaling through parallel generation. Unlike benchmark
generators, it is not tied to a fixed schema. Unlike ML-based tools, it does not
require real data. Unlike many declarative tools, it is designed as a practical
generation engine that can produce large datasets from compact specifications.

The remaining gap, and the focus of this extension, is automation and
verification. V1 established that annotated schemas are expressive enough to
produce high-fidelity synthetic data, but the annotations themselves were largely
manual. The present work automates that step by extracting schema metadata and
optimizer statistics, generating the DataGenX annotations, preserving
referential integrity, regenerating optimizer-visible statistics on the target,
and validating the result through both data-level and query-plan checks. In this
sense, the system advances DataGenX from a manual annotation framework toward
an end-to-end workflow for privacy-preserving, optimizer-faithful synthetic
database generation.

The contribution is not merely another data generator. It is a practical bridge
between the information database systems already expose to their optimizers and
the synthetic data needed for testing those same optimizers. This bridge is
particularly relevant for TPC Technology Conference audiences because it connects
benchmark-style reproducibility with real-world constraints: fixed benchmark
generators are too rigid, raw production data is often unavailable, and query
optimizer behavior depends on statistical details that simpler synthetic data
tools do not preserve.

More specifically, this work contributes four pieces that are not provided
together by prior systems. First, it automates the translation from an existing
schema and optimizer-visible statistics into DataGenX generation templates,
reducing the manual annotation burden of DataGenX V1. Second, it treats
optimizer fidelity as the primary target: row counts, key relationships,
histogram shapes, distinct counts, and predicate selectivities are the objects
to preserve, rather than source-row resemblance. Third, it validates histogram
equivalence by comparing distribution shape rather than literal bucket values,
which allows synthetic domains to differ from source domains. Fourth, it
supports query-plan validation over synthetic values by building a local
source-to-target literal mapping and rewriting target-side predicates before
plan comparison. Together, these pieces form an end-to-end workflow for
privacy-preserving, optimizer-faithful synthetic database generation.

## References to Carry Into the Paper

The following references are the most relevant for this section. The citation
keys are placeholders intended to be replaced by the paper's BibTeX keys.

- [RablJacobsen2014] Tilmann Rabl and Hans-Arno Jacobsen. "Big Data Generation."
  In *Specifying Big Data Benchmarks*, LNCS 8163, Springer, 2014.
  DOI: 10.1007/978-3-642-53974-9_3.
- [RablEtAl2013PDGF] Tilmann Rabl, Meikel Poess, Manuel Danisch, and Hans-Arno
  Jacobsen. "Rapid Development of Data Generators Using Meta Generators in
  PDGF." In *DBTest 2013*, 2013. DOI: 10.1145/2479440.2479441.
- [RablEtAl2013SSB] Tilmann Rabl, Meikel Poess, Hans-Arno Jacobsen, Patrick
  O'Neil, and Elizabeth O'Neil. "Variations of the Star Schema Benchmark to Test
  the Effects of Data Skew on Query Performance." In *ICPE 2013*, pp. 361-372,
  2013. DOI: 10.1145/2479871.2479927.
- [GhazalCrolotte2011] Ahmad Ghazal and Alain Crolotte. "Introducing Skew into
  the TPC-H Benchmark." In *TPC Technology Conference*, 2011. DOI:
  10.1007/978-3-642-32627-1_10.
- [GhazalEtAl2013] Ahmad Ghazal, Tilmann Rabl, Minqing Hu, Francois Raab, Meikel
  Poess, Alain Crolotte, and Hans-Arno Jacobsen. "BigBench: Towards an Industry
  Standard Benchmark for Big Data Analytics." In *SIGMOD 2013*, 2013. DOI:
  10.1145/2463676.2463712.
- [RablEtAl2015BigBench] Tilmann Rabl, Michael Frank, Manuel Danisch, Bhaskar
  Gowda, and Hans-Arno Jacobsen. "Towards a Complete BigBench Implementation."
  In *Big Data Benchmarking*, LNCS 8991, Springer, 2015. DOI:
  10.1007/978-3-319-20233-4_1.
- [RablEtAl2015Synth] Tilmann Rabl, Manuel Danisch, Michael Frank, Sebastian
  Schindler, and Hans-Arno Jacobsen. "Just Can't Get Enough: Synthesizing Big
  Data." In *SIGMOD 2015*, pp. 1457-1462, 2015. DOI:
  10.1145/2723372.2735378.
- [AlexandrovEtAl2011] Alexander Alexandrov, Berni Schiefer, John Poelman,
  Stephan Ewen, Thomas O. Bodner, and Volker Markl. "Myriad: Parallel Data
  Generation on Shared-Nothing Architectures." PACT workshop paper, 2011.
