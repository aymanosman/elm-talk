build: elm snap

snap:
	stack build --flag snappy:development

elm:
	cd src-elm
	elm-make Main.elm --output ../static/elm.js
