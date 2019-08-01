'use strict';

module.exports = function(Product) {
    Product.prototype.getprice = function(){
        return this.price;
    }
};
