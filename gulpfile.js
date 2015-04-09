var gulp = require('gulp');
var coffee = require('gulp-coffee');
var uglify = require('gulp-uglifyjs');
var gutil = require('gulp-util');

gulp.task('full', function() {
  gulp.src('./src/fallout.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./dist/'))
});

gulp.task('min', function() {
  gulp.src('./src/fallout.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(uglify('fallout.min.js'))
    .pipe(gulp.dest('./dist/'))
});

gulp.task('default', ['full','min']);
