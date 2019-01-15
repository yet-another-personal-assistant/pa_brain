FROM mcreations/sbcl:1.4.11
LABEL "component"="brain"
LABEL "version"="0.5.0"

ADD *.lisp /opt/brain/
ADD deploy/ql.lisp /tmp
RUN sbcl --script /tmp/ql.lisp

WORKDIR /opt/brain
ENTRYPOINT ["sbcl", "--script", "/opt/brain/run.lisp"]
CMD ["--translator", "tr:8001"]
