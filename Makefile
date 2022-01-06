.PHONY: sync

sync:
	npm i --save @primer/primitives@latest
	cp -R ./node_modules/@primer/primitives/dist/json/colors/ ./data/colors
