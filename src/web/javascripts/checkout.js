var carrierCosts = {
    "UPS": 5,
    "USPS": 4,
    "FedEx": 3,
    "Canada Post": 2
};

var shippingCosts = {
    "Normal": 2,
    "Express": 5,
    "Overnight": 10
};

function updateCostCellValues() {
    var $shippingCarrierInput = $('#shipping-carrier-input');
    var $shippingOptionInput = $('#shipping-option-input');
    var $costCell = $('#order-cost-cell');
    var $shippingCostCell = $('#order-shipping-cell');
    var $totalCostCell = $('#order-total-cell');

    var shippingCost = Number(carrierCosts[$shippingCarrierInput[0].value] + shippingCosts[$shippingOptionInput[0].value]);
    var totalCost = shippingCost + Number($costCell.data('value'));

    $shippingCostCell.text("$" + shippingCost.toFixed(2));
    $totalCostCell.text("$" + totalCost.toFixed(2));
}


$(document).ready(function() {
    var $shippingInput = $('#shipping-carrier-input, #shipping-option-input');

    updateCostCellValues();
    $shippingInput.on('change', updateCostCellValues);
});