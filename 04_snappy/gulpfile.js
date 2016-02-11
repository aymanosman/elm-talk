/* global require, console */
"use strict";

var gulp = require("gulp");
var gulpSequence = require('gulp-sequence');
var del = require("del");
var browserSync = require("browser-sync");
var elm = require('gulp-elm');
var fs = require('fs');
var plumber = require("gulp-plumber");
var reload = browserSync.reload;

gulp.task("clean:dev", function(cb) {
  return del(["serve"], cb);
});

gulp.task("copy:dev", function() {
  return gulp.src(["src-elm/index.html"])
    .pipe(gulp.dest("static"));
});

var bs;
gulp.task("serve:dev", ["build"], function() {
  bs = browserSync({
    notify: true,
    server: {
      baseDir: "static"
    }
  });
});

gulp.task('elm-init', elm.init);
gulp.task('elm', ['elm-init'], function() {
  return gulp.src('src-elm/elm/Main.elm')
    .pipe(plumber())
    .pipe(elm())
    .on('error', function(err) {
      console.error(err.message);
      browserSync.notify("Elm compile error", 5000);
      fs.writeFileSync('static/index.html', "<!DOCTYPE HTML><html><body><pre>" +
                       err.message + "</pre></body></html>");
    })
    .pipe(gulp.dest('static'));
});

gulp.task("watch", function() {
  gulp.watch(["src-elm/index.html"], ["copy:dev", reload]);
  gulp.watch(["src-elm/*.elm"], ["elm", "copy:dev", reload]);
});

gulp.task("default", ["serve:dev", "watch"]);
gulp.task("build", gulpSequence("clean:dev", ["copy:dev", "elm"]));
