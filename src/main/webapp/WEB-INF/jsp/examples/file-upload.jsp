<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
  #files ul {
    list-style-type: none;
  }
  #files li {
    display: inline-block;
    width: 340px;
  }
  #files li canvas {
    float: left;
  }
  #files li div {
    float: left;
    margin-left: 10px;
  }
</style>
<div class="t50 b20">
  <blockquote>
    <p>File Upload widget with multiple file selection, drag&amp;drop support, progress bars, validation and preview images, audio and video for jQuery.<br>
      Supports cross-domain, chunked and resumable file uploads and client-side image resizing.<br>
      Works with any server-side platform (PHP, Python, Ruby on Rails, Java, Node.js, Go etc.) that supports standard HTML form file uploads.</p>
  </blockquote>
  <br>
  <!-- The file upload form used as target for the file upload widget -->
  <form id="fileupload" action="https://jquery-file-upload.appspot.com/" method="POST" enctype="multipart/form-data">
    <!-- Redirect browsers with JavaScript disabled to the origin page -->
    <noscript><input type="hidden" name="redirect" value="https://blueimp.github.io/jQuery-File-Upload/"></noscript>
    <label for="fileAdds" class="button fileinput-button">Add files...</label>
    <input type="file" name="files[]" id="fileAdds" class="show-for-sr" multiple>
    <div id="progress" class="success progress">
      <div class="progress-meter"></div>
    </div>
    <div id="files"><ul></ul></div>
  </form>
  <br>
  <div class="panel panel-default">
    <div class="panel-heading">
      <h3 class="panel-title">Demo Notes</h3>
    </div>
    <div class="panel-body">
      <ul>
        <li>The maximum file size for uploads in this demo is <strong>999 KB</strong> (default file size is unlimited).</li>
        <li>Only image files (<strong>JPG, GIF, PNG</strong>) are allowed in this demo (by default there is no file type restriction).</li>
        <li>Uploaded files will be deleted automatically after <strong>5 minutes or less</strong> (demo files are stored in memory).</li>
        <li>You can <strong>drag &amp; drop</strong> files from your desktop on this webpage (see <a href="https://github.com/blueimp/jQuery-File-Upload/wiki/Browser-support">Browser support</a>).</li>
        <li>Please refer to the <a href="https://github.com/blueimp/jQuery-File-Upload">project website</a> and <a href="https://github.com/blueimp/jQuery-File-Upload/wiki">documentation</a> for more information.</li>
        <li>Built with the <a href="http://getbootstrap.com/">Bootstrap</a> CSS framework and Icons from <a href="http://glyphicons.com/">Glyphicons</a>.</li>
      </ul>
    </div>
  </div>
</div>
<!-- The jQuery UI widget factory, can be omitted if jQuery UI is already included -->
<script src="/assets/js/vendor/jquery.ui.widget.js"></script>
<!-- The Templates plugin is included to render the upload/download listings -->
<script src="https://blueimp.github.io/JavaScript-Templates/js/tmpl.min.js"></script>
<!-- The Load Image plugin is included for the preview images and image resizing functionality -->
<script src="https://blueimp.github.io/JavaScript-Load-Image/js/load-image.all.min.js"></script>
<!-- The Canvas to Blob plugin is included for image resizing functionality -->
<script src="https://blueimp.github.io/JavaScript-Canvas-to-Blob/js/canvas-to-blob.min.js"></script>
<!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
<script src="/assets/js/jquery.iframe-transport.js"></script>
<!-- The basic File Upload plugin -->
<script src="/assets/js/jquery.fileupload.js"></script>
<!-- The File Upload processing plugin -->
<script src="/assets/js/jquery.fileupload-process.js"></script>
<!-- The File Upload image preview & resize plugin -->
<script src="/assets/js/jquery.fileupload-image.js"></script>
<!-- The File Upload audio preview plugin -->
<script src="/assets/js/jquery.fileupload-audio.js"></script>
<!-- The File Upload video preview plugin -->
<script src="/assets/js/jquery.fileupload-video.js"></script>
<!-- The File Upload validation plugin -->
<script src="/assets/js/jquery.fileupload-validate.js"></script>
<script>
  /*jslint unparam: true, regexp: true */
  /*global window, $ */
  $(function () {
    'use strict';
    // Change this to the location of your server-side upload handler:
    var url = window.location.hostname !== 'blueimp.github.io' ?
      '//jquery-file-upload.appspot.com/' : 'server/php/',
      uploadButton = $('<button/>')
          .attr("type", "button")
          .addClass('button success')
          .prop('disabled', true)
          .text('Processing...')
          .on('click', function () {
              var $this = $(this),
                  data = $this.data();
              $this
                  .off('click')
                  .text('Abort')
                  .on('click', function () {
                      $this.remove();
                      data.abort();
                  });
              data.submit().always(function () {
                  $this.remove();
              });
              $("#progress").removeClass("alert").addClass("success");
          });
    $('#fileupload').fileupload({
      url: url,
      dataType: 'json',
      autoUpload: false,
      acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
      maxFileSize: 999000,
      // Enable image resizing, except for Android and Opera,
      // which actually support image resizing, but fail to
      // send Blob objects via XHR requests:
      disableImageResize: /Android(?!.*Chrome)|Opera/
          .test(window.navigator.userAgent),
      previewMaxWidth: 100,
      previewMaxHeight: 100,
      previewCrop: true
    }).on('fileuploadadd', function (e, data) {
      data.context = $('<li/>').appendTo($('#files ul'));
      $.each(data.files, function (index, file) {
          var node = $('<div/>')
              .append($('<p/>').text(file.name));
          if (!index) {
              node.append(uploadButton.clone(true).data(data));
          }
          node.appendTo(data.context);
      });
    }).on('fileuploadprocessalways', function (e, data) {
      var index = data.index,
          file = data.files[index],
          node = $(data.context[index]);
      if (file.preview) {
          node.prepend(file.preview);
      }
      if (file.error) {
          node.find("div")
              .append($('<span class="label alert"/>').text(file.error));
      }
      if (index + 1 === data.files.length) {
          data.context.find('button')
              .text('Upload')
              .prop('disabled', !!data.files.error);
      }
    }).on('fileuploadprogressall', function (e, data) {
      var progress = parseInt(data.loaded / data.total * 100, 10);
      $('#progress .progress-meter').css(
          'width',
          progress + '%'
      );
    }).on('fileuploaddone', function (e, data) {
      $.each(data.result.files, function (index, file) {
          if (file.url) {
              var link = $('<a>')
                  .attr('target', '_blank')
                  .prop('href', file.url);
              $(data.context[index])
                  .wrap(link);
          } else if (file.error) {
              var error = $('<span class="label alert"/>').text(file.error);
              $(data.context[index]).find("div")
                  .append(error);
          }
      });
    }).on('fileuploadfail', function (e, data) {
      $.each(data.files, function (index) {
            var error = $('<span class="label alert"/>').text('File upload failed.');
            $(data.context[index]).find("div")
                .append(error);
        });
      $("#progress").removeClass("success").addClass("alert");
      $("#progress .progress-meter").css("width", "100%");
    }).prop('disabled', !$.support.fileInput)
        .parent().addClass($.support.fileInput ? undefined : 'disabled');
  });
</script>