all: workspaces/step0_repl.xml workspaces/step1_read_print.xml \
     workspaces/step2_eval.xml

workspaces/%.xml: %.apl
	mkdir -p workspaces
	apl --OFF --noCONT -f $<

workspaces/printer.xml: workspaces/types.xml

STEP1_DEPS = workspaces/reader.xml workspaces/printer.xml
STEP2_DEPS = $(STEP1_DEPS) workspaces/types.xml

workspaces/step1_read_print.xml: $(STEP1_DEPS)
workspaces/step2_eval.xml: $(STEP2_DEPS)

clean:
	rm workspaces/*.xml
