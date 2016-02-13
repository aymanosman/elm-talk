build: snap elm

elm:
	elm-make src-elm/Main.elm --output static/elm.js

snap:
	stack build --flag snappy:development

serve:
	stack exec snappy -- -p 8002
