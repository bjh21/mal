all: workspaces/step0_repl.xml workspaces/step1_read_print.xml

workspaces/%.xml: %.apl
	mkdir -p workspaces
	apl --OFF --noCONT -f $<

workspaces/printer.xml: workspaces/types.xml

workspaces/step1_read_print.xml: workspaces/reader.xml workspaces/printer.xml

clean:
	rm workspaces/*.xml
