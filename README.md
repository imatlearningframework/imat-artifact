GETTING STARTED
===============

1. This artifact has been prepared for ECOOP '23 R1 Artifact Submission.
   The artifact is a docker image containing everything described in the draft.

2.  Install [git-lfs](https://git-lfs.github.com). Then run:

        $ git lfs install

3.  Next, clone the artifact repository:

        $ git clone https://github.com/imatlearningframework/imat-artifact.git
        $ cd imat-artifact

4. Install [docker](https://docs.docker.com/)

5. To load and start the docker image, run:

        $ docker load < imat-artifact-image.tar.gz
        $ docker run -it imat/base

6. The docker image is built on the [opam docker image](https://hub.docker.com/r/ocaml/opam) for
   OCaml 4.14 and is laid out as follows:
    * All of the OCaml source code is in `/home/opam/imat-source`.
    * There is a library of automata manipulation modules in `/home/opam/imat-sorce/nerode`.
    * There is a library of automata learning algorithms in `/home/opam/imat-source/nerode-learn`.
      The docker image starts out in the nerode-learn directory (as all the
      scripts are designed to be run from here). Note in particular that the
      main algorithm from the paper, L* with Blanks, is implemented in
      `/home/opam/imat-source/nerode-learn/lib/lstarblanks.ml`.  The
      implementation of the observation table data structure (described in the
      early part of section 8) is in
      `/home/opam/imat-source/nerode-learn/lib/obsTbl.ml`.
    * An auxiliary library for interacting with the Z3 SMT solver is
      provided in `/home/opam/imat-source/ocaml-z3`.
    * Benchmark sets are provided in `/home/opam/imat-source/benchmarks`.
      The benchmarks in the subdirectory `oliveira` are due to
      [Oliveira and Silva](https://ieeexplore.ieee.org/document/712986) and
      those in `lee_alpharegex` are due [Lee, So, and Oh](https://dl.acm.org/doi/10.1145/2993236.2993244).
    * Finally we provide bash scripts for reproducing the various experiments in
      section 9 of the paper in `/home/opam/imat-source/scripts`. In particular,
      `/home/opam/imat-source/scripts/reproduce-abridged.sh` and
      `/home/opam/imat-source/scripts/reproduce-everything.sh` make a new
      directory, `/home/opam/imat-source/output`, and produce CSV files into
      that directory with the corresponding data.

7. Once the docker has started, a very simple command to verify that things are
   working:
    
        $ dune exec nerodelearn -- lsblanks-sep "00*" "11*"

            For this example, L+ = 00* and L- = 11*. The system should learn a 2 state DFA:

               | 0 1    <--- these are the alphabet symbols
            ---+----
             0 | 1 0    <--- this is the start state (always 0)
             1 | 1 0 *  <--- this is an accepting state (indicated by *)
            Dfa size: 2
            1*0(0+11*0)* <-- corresponding regex (naively converted)


    Or, to run on a finite list of example strings (the flags -s and -ge are,
    respectively the unsat-cores and suffix-set sharing optimizations):

        $ dune exec nerodelearn -- lsblanks -s -ge ../benchmarks/lee_alpharegex/1


            Popped_Items:	6
            Query Count:	27
            Conjectures:	3
            Conjecture_Time:	0.000112
            Cols_Update_Time:	0.000003
            BlankSMT_Time:	0.139428
            Learn Time:	0.140595
            Total Popped_Items:	6
            Total Conjectures:	3
            Total Conjecture_Time:	0.000112
            Total Cols_Update_Time:	0.000003
            Total BlankSMT_Time:	0.139428
            Total Learn Time:	0.140595
            
               | 0 1
            ---+----
             0 | 2 1
             1 | 1 1
             2 | 2 2 *
            0(0+1)*

8.  The following commands run L* with Blanks on the benchmarks mentioned in the
    paper (in csv format: the -f option). Time estimates are for a laptop with a
    1.4 GHz Intel Core i5 with 8GB RAM running docker on MacOS (Monterey).

    Abridged version of Figure-6 (should take 10min):

        $ ../scripts/reproduce-abridged.sh

    Small example of separating regular expressions in section 8 (end of page 21) (will take <1 second):

        $ dune exec nerodelearn -- lsblanks-sep "(0101)*" "10*"

    Table 1 (should take 25min):

        $ dune exec nerodelearn -- lsblanks-dir -s -ge -f ../benchmarks/table-1

    Data for Figure 6(a) (should take 45 min and 5-6 hours, respectively):

        $ dune exec nerodelearn -- lsblanks-dir -ge -f ../benchmarks/oliveira/04_09
        $ dune exec nerodelearn -- lsblanks-dir -s -ge -f ../benchmarks/oliveira/04_09

    Data for Figure 6(b) (may take more than a day):

        $ dune exec nerodelearn -- lsblanks-dir -s -ge -f ../benchmarks/oliveira/04_11

    Everything in the paper, all in one go (may take a more than a day):

        $ ../scripts/reproduce-everything.sh

