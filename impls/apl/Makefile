all: workspaces/step0_repl.xml workspaces/step1_read_print.xml \
     workspaces/step2_eval.xml workspaces/step3_env.xml \
     workspaces/step4_if_fn_do.xml workspaces/step5_tco.xml \
     workspaces/step6_file.xml

workspaces/%.xml: %.apl
	mkdir -p workspaces
	apl --OFF --noCONT -f $<

workspaces/reader.xml: workspaces/types.xml
workspaces/printer.xml: workspaces/types.xml
workspaces/env.xml: workspaces/types.xml
workspaces/core.xml: workspaces/types.xml

STEP1_DEPS = workspaces/reader.xml workspaces/printer.xml
STEP2_DEPS = $(STEP1_DEPS) workspaces/types.xml
STEP3_DEPS = $(STEP2_DEPS) workspaces/env.xml
STEP4_DEPS = $(STEP3_DEPS) workspaces/core.xml

workspaces/step1_read_print.xml: $(STEP1_DEPS)
workspaces/step2_eval.xml: $(STEP2_DEPS)
workspaces/step3_env.xml: $(STEP3_DEPS)
workspaces/step4_if_fn_do.xml: $(STEP4_DEPS)
workspaces/step5_tco.xml: $(STEP4_DEPS)
workspaces/step6_file.xml: $(STEP4_DEPS)

clean:
	rm workspaces/*.xml
