build: app elm

serve:
	stack exec mascot

app:
	stack build

elm:
	elm-make src-elm/Main.elm --output static/Main.js

dev:
	nodemon --exec 'stack runghc app/Main.hs' -w app/Main.hs
