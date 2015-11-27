$(document).ready(function() {
    var query = location.search.slice(1).split('&');

    $.each(query, function(i, filter) {
        var filters = filter.split('=');
        if (filters.length === 2) {
            var fName = filters[0].replace("[]", "").toLowerCase();
            var fVal = filters[1].toLowerCase();

            if (fName === "search") {
                $('#browse-search-input').val(fVal);
            }
            else {
                $('.filter-checkbox[name=' + fName +'][value=' + fVal + ']').prop('checked', true);
            }
        }
    });
});