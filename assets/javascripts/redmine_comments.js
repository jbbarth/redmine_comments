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
            $('.visibility .comment_role.involved').each(function () {
                authorized.push($(this).data('role-id'))
            });
            $('#journal_visibility').val(authorized.join('|'));

            // Update disabled class
            form_id = $(this).closest('form').attr('id')
            disable_last_role(form_id);
        }
    });
});
