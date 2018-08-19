from runner import Runner

def before_all(context):
    context.runner = Runner()
    context.runner.update_config({"main": {"command": "sbcl --script run.lisp --quit", "type": "stdio"}})
