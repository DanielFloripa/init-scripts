define(
[],
function() {
	var cardsList = {};

	var list = [
	{
		name : 'Amex',
		regexpBin : /^3[47]\d{13}$/,
		regexpCvv : /^\d{3,4}$/
	},
	{
		name : 'Mastercard',
		regexpBin : /^5(?!04175|067|06699)\d{15}$/,
		regexpCvv : /^\d{3}$/
	},
	{
		name : 'Visa',
		regexpBin : /^4(?!38935|011|51416|576)\d{12}(?:\d{3})?$/,
		regexpCvv : /^\d{3}$/
	},
	{
		name : 'Elo',
		regexpBin : /^401178|^401179|^431274|^438935|^451416|^457393|^457631|^457632|^504175|^627780|^636297|^636368|^(506699|5067[0-6]\d|50677[0-8])|^(50900\d|5090[1-9]\d|509[1-9]\d{2})|^65003[1-3]|^(65003[5-9]|65004\d|65005[0-1])|^(65040[5-9]|6504[1-3]\d)|^(65048[5-9]|65049\d|6505[0-2]\d|65053[0-8])|^(65054[1-9]|6505[5-8]\d|65059[0-8])|^(65070\d|65071[0-8])|^65072[0-7]|^(65090[1-9]|65091\d|650920)|^(65165[2-9]|6516[6-7]\d)|^(65500\d|65501\d)|^(65502[1-9]|6550[3-4]\d|65505[0-8])/,
		regexpCvv : /^\d{3}$/
	}, {
		name : 'Diners',
		regexpBin : /^3(?:0[0-5]|[68][0-9])[0-9]{11}$/,
		regexpCvv : /^\d{3}$/
	}, {
		name : 'Hipercard',
		regexpBin : /^(38|60)\d{11}(?:\d{3})?(?:\d{3})?$/,
		regexpCvv : /^\d{3}$/
	}, {
		name : 'Aura',
		regexpBin : /^50[0-9]/,
		regexpCvv : /^\d{3}$/
	} ];

	cardsList.getCardsList = function(newBrands) {
		var brands = newBrands ? list : list.slice( 0, 3 );
		return brands;
	}

	return cardsList;
} );
