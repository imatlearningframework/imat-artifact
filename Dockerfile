# We start with ocaml/opam from the official source.
FROM ocaml/opam

# Set up the appropriate OPAM env (i.e. $ eval $(opam env))
ENV OPAM_SWITCH_PREFIX='/home/opam/.opam/4.14'
ENV CAML_LD_LIBRARY_PATH='/home/opam/.opam/4.14/lib/stublibs:/home/opam/.opam/4.14/lib/ocaml/stublibs:/home/opam/.opam/4.14/lib/ocaml'
ENV OCAML_TOPLEVEL_PATH='/home/opam/.opam/4.14/lib/toplevel'
ENV MANPATH=':/home/opam/.opam/4.14/man'
ENV PATH='/home/opam/.opam/4.14/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

# Install dependencies
RUN sudo apt-get update && sudo apt-get install -y z3 && sudo apt-get install -y libgmp-dev

# For figure-generating scripts
RUN sudo apt-get install -y python3 && sudo apt-get install -y python3-pip
RUN pip3 install matplotlib

# Install ocaml/opam project dependencies
RUN opam install dune

# Get the source code
RUN git clone https://github.com/imatlearningframework/imat-source.git
RUN sudo chown -R opam:opam /home/opam/imat-source

# Build the ocaml-z3 bindings
WORKDIR /home/opam/imat-source/ocaml-z3
RUN opam install --deps .
RUN dune build
RUN dune install

# Build nerode library
WORKDIR /home/opam/imat-source/nerode
RUN opam install --deps .
RUN dune build
RUN dune install

# Build nerode-learn library
WORKDIR /home/opam/imat-source/nerode-learn
RUN opam install --deps .
RUN dune build
