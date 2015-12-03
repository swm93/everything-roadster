function updateSelect(el, vs, filter) {
    var type = el.name;
    var html = "";
    var filteredVs = _.uniq(_.pluck(_.where(vs, filter), type));

    $.each(filteredVs, function(i, v) {
        html += createOptionHtml(v);
    });

    $(el).html(html);
}

function createOptionHtml(value) {
    return '<option value="' + value + '">' + value + '</option>';
}

function getFilter(filterEl, $els) {
    var filter = {};
    var filters = ["makeName", "modelName", "year"];
    filters = _.omit(filters, filters.splice(_.indexOf(filters, filterEl.name)));

    $.each($els, function(i, el) {
        if (_.contains(filters, el.name)) {
            filter[el.name] = el.value;
        }
    });

    return filter;
}


$(document).ready(function() {
    var $filteredSelect = $('.filtered-select');

    $.each($filteredSelect, function(i, el) {
        updateSelect(el, vehicles, getFilter(el, $filteredSelect));
    });

    $filteredSelect.on('change', function() {
        var that = this;
        var found = false;
        $.each($filteredSelect, function(i, el) {
            if (found) {
                updateSelect(el, vehicles, getFilter(el, $filteredSelect));
            }

            if (that.name === el.name) {
                found = true;
            }
        });
    });
});