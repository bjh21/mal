all: workspaces/step0_repl.xml

workspaces/%.xml: %.apl
	mkdir -p workspaces
	apl --OFF -f $<

clean:
	rm workspaces/*.xml
