//disable last role so user cannot remove all roles
function disable_last_role(container_id) {
    let container = $("#" + container_id)
    if (container.find('.visibility .comment_role.involved').length !== 1) {
        container.find('.visibility .comment_role').removeClass('disabled');
    } else {
        container.find('.visibility .comment_role.involved').addClass('disabled');
    }
}


//add a mirroring between selected visibility roles and
//the hidden field => 1|4|5|...
$(function () {
    $('#content').on('click', '.visibility .comment_role', function () {
        if (!$(this).hasClass('disabled')) {
            $(this).toggleClass('involved');
            var authorized = [];
            var journal_id = $(this).data('journal-id');
            $('.visibility .comment_role.involved[data-journal-id="' + journal_id + '"]').each(function () {
                authorized.push($(this).data('role-id'))
            });
            $('#journal_visibility[data-id="' + journal_id + '"]').val(authorized.join('|'));

            // Update disabled class
            form_id = $(this).closest('form').attr('id')
            disable_last_role(form_id);
        }
    });
});

$(document).ready(function(){
  // override copyImageFromClipboard of core Redmine
  copyImageFromClipboard = function (e) {
      if (!$(e.target).hasClass('wiki-edit')) { return; }
      var clipboardData = e.clipboardData || e.originalEvent.clipboardData
      if (!clipboardData) { return; }
      if (clipboardData.types.some(function(t){ return /^text\/plain$/.test(t); })) { return; }

      var items = clipboardData.items
      for (var i = 0 ; i < items.length ; i++) {
        var item = items[i];

        var blob = item.getAsFile();
        if (item.type.indexOf("image") != -1 && blob) {
          var date = new Date();
          var filename = 'clipboard-'
            + date.getFullYear()
            + ('0'+(date.getMonth()+1)).slice(-2)
            + ('0'+date.getDate()).slice(-2)
            + ('0'+date.getHours()).slice(-2)
            + ('0'+date.getMinutes()).slice(-2)
            + '-' + randomKey(5).toLocaleLowerCase()
            + '.' + blob.name.split('.').pop();
          var file = new Blob([blob], {type: blob.type});
          file.name = filename;
          // get input file in the closest form
          var inputEl = $(this).closest("form").find('input:file.filedrop');
          handleFileDropEvent.target = e.target;
          addFile(inputEl, file, true);
        }
      }
    }
});