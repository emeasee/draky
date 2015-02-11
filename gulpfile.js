var gulp = require('gulp'),
    gulpLoadPlugins = require('gulp-load-plugins'),
    plugins = gulpLoadPlugins(),
    browserSync = require('browser-sync'),
    del = require('del');

// Update to do SCSS compiling since we don't use Brackets anymore
gulp.task('clean', function(cb){
    del([
        'build/**/*'
    ], cb);
});

gulp.task('usemin', function () {
    return gulp.src('app/*.html')
        .pipe(plugins.usemin({
            css: [plugins.autoprefixer({browsers:['last 2 versions'], cascade: false}), plugins.minifyCss(), 'concat'],
            //html: [plugins.minifyHtml({empty: true})],
            js: [plugins.stripDebug(), plugins.uglify(), plugins.rev(), 'concat']
        }))
        .pipe(gulp.dest('build/'));
});

gulp.task('browser-sync', function () {
   var files = [
      'app/**/*.html',
      'app/css/**/*.css',
      'app/imgs/**/*.png',
      'app/js/**/*.js'
   ];

   browserSync.init(files, {
      server: {
      baseDir: './app'
      }
   });
});

gulp.task('build', ['clean'], function(){
    gulp.start('usemin');
});

gulp.task('deploy', function () {
    return gulp.src('./build/**/*')
        .pipe(plugins.deploy(options));
});
