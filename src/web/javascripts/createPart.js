function createFitsInFormHtml($el, index, vs) {
    var html = '\
    <div class="row">\
        <div class="col-xs-12 col-sm-5 form-group">\
            <label for="make-name-input-' + index + '">Make Name</label>\
            <select id="make-name-input-' + index + '" class="form-control filtered-select-' + index + '" data-index="' + index + '" name="fitsInMakeName[]">\
            </select>\
        </div>\
        <div class="col-xs-12 col-sm-5 form-group">\
            <label for="model-name-input-' + index + '">Model Name</label>\
            <select id="model-name-input-' + index + '" class="form-control filtered-select-' + index + '" data-index="' + index + '" name="fitsInModelName[]">\
            </select>\
        </div>\
        <div class="col-xs-12 col-sm-2 form-group">\
            <label for="year-input-' + index + '">Year</label>\
            <select id="year-input-' + index + '" class="form-control filtered-select-' + index + '" data-index="' + index + '" name="fitsInYear[]">\
            </select>\
        </div>\
    </div>';

    $el.append(html);

    var $filteredSelect = $('.filtered-select-' + index, $el);
    $.each($filteredSelect, function(i, el) {
        updateSelect(el, vs, getFilter(el, $filteredSelect));
    });

    $filteredSelect.on('change', function() {
        var that = this;
        var found = false;
        $.each($filteredSelect, function(i, el) {
            if (found) {
                updateSelect(el, vs, getFilter(el, $filteredSelect));
            }

            if (that.name === el.name) {
                found = true;
            }
        });
    });
}

function createFitsInOptionHtml(value) {
    return '<option value="' + value + '">' + value + '</option>';
}

function updateSelect(el, vs, filter) {
    var type = getType(el.name);
    var html = "";
    var filteredVs = _.uniq(_.pluck(_.where(vs, filter), type));

    $.each(filteredVs, function(i, v) {
        html += createFitsInOptionHtml(v);
    });

    $(el).html(html);
}

function getFilter(filterEl, $els) {
    var filter = {};
    var filters = ["makeName", "modelName", "year"];
    filters = _.omit(filters, filters.splice(_.indexOf(filters, getType(filterEl.name))));

    $.each($els, function(i, el) {
        var type = getType(el.name);
        if (_.contains(filters, type)) {
            filter[type] = el.value;
        }
    });

    return filter;
}

function getType(name) {
    var nameTypeMapping = {
        'fitsInMakeName[]': 'makeName',
        'fitsInModelName[]': 'modelName',
        'fitsInYear[]': 'year'
    };

    return nameTypeMapping[name];
}


$(document).ready(function() {
    var $partFitsInContainer = $('#part-fits-in-container');
    var $addFitsInBtn = $('#add-fits-in-btn');
    var index = 0;

    createFitsInFormHtml($partFitsInContainer, index++, vehicles);

    $addFitsInBtn.on('click', function() {
        createFitsInFormHtml($partFitsInContainer, index++, vehicles);
    });
});