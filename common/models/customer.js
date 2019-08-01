const { utils } = require('loopback-boot');
'use strict';

const app = require('./../../server/server');
module.exports = function (Customer) {
    // debugger;
    Customer.shopcart = async function (id, req, ctx) {

        const Product2 = app.models.Product;
        const Product = Customer.app.models.Product;

        const user = await Customer.findById(ctx.req.accessToken.userId);
        const products = user.shopCart.map(async (prod) => {
            const product = await Product.findById(prod.productId);
            return { product, quantity: prod.quantity };
        });
        let p = await Promise.all(products);
        return p;
    }
    Customer.shopcartcount = async function (id, req, ctx) {

        const Product2 = app.models.Product;
        const Product = Customer.app.models.Product;

        const user = await Customer.findById(ctx.req.accessToken.userId);
        return user.shopCart.length;
    };

    Customer.addtocart = async function (id, product, req) {

        const user = await Customer.findById(req.accessToken.userId);
        user.shopCart = user.shopCart || [];
        const products = user.shopCart.map(prod => (
            prod.productId
        ));
        products.includes(product.productId) ?
            user.shopCart = user.shopCart.map(prod => (
                prod.productId === product.productId ?
                    { ...prod, quantity: prod.quantity += product.quantity } : prod
            ))
            : user.shopCart = [...user.shopCart, product];
        await user.save();
        return user.shopCart.length;
    };

    Customer.editcart = async function (id, product, req) {

        const user = await Customer.findById(req.accessToken.userId);
        const { shopCart: cart } = user;
        if (product.remove) {
            user.shopCart = cart.filter(prod => prod.productId !== product.productId);
        } else {
            user.shopCart = cart.map(prod => (
                prod.productId === product.productId ?
                    { ...prod, quantity: product.quantity } : prod
            ));
        }
        await user.save();
        return user.shopCart.length;
    };

    Customer.generatepayment = async function (id, req, ctx) {
        const Product = Customer.app.models.Product;
        const Bill = Customer.app.models.Bill;

        const user = await Customer.findById(req.accessToken.userId, { fields: ['shopCart'] });
        const { shopCart: cart } = user;
        // let user =await Customer.findOne({where: {and:[{id:req.accessToken.userId}]},fields:['shopCart']});
        // user = user.toJSON();
        let products = cart.map(async (prod) => {
            const { price, name } = await Product.findById(prod.productId, { fields: ['price', 'name'] });
            return { price, name, quantity: prod.quantity };
        });
        products = await Promise.all(products);
        const total = products.reduce((total, item) => total + item.price * item.quantity, 0);
        const query = require('querystring');

        const params1 = products.reduce((obj, item, index) => {
            obj = {
                ...obj,
                [`li_${index}_name`]: item.name,
                [`li_${index}_price`]: item.price,
                [`li_${index}_quantity`]: item.quantity,
                [`li_${index}_type`]: `product${index}`,
            };
            return obj;
        }, {});

        let billId;
        let bill = await Bill.create({
            customerId: id,
            total
        });
        // const bill1 = bill.toJSON();
        billId = bill.toJSON().id.toJSON()
        const bbb = user.bills();
        const params = {
            ...params1,
            userId: id,
            billId,
            sid: '901411935',
            mode: '2CO',
            mycustomkey: 'customid',
            card_holder_name: 'Checkout Shopper',
            street_address: '123 Test Address',
            street_address2: 'Suite 200',
            city: 'Columbus',
            state: 'OH',
            zip: '43228',
            country: 'EGP',
            email: 'example@2co.com',
            phone: '614-921-2450',
        };
        // return user;
        const q = query.stringify(params);
        debugger;
        return (`https://sandbox.2checkout.com/checkout/purchase?${q}`);
    };

    Customer.remoteMethod('shopcart', {
        accepts: [
            { arg: 'id', type: 'string' },
            { arg: 'req', type: 'object', http: { source: 'req' } },
            { arg: 'ctx', type: 'object', http: { source: 'context' } }
        ],
        returns: [{ arg: 'cart', type: 'array' }],
        http: { verb: 'get', path: '/:id/shopcart' },
    });

    Customer.remoteMethod('addtocart', {
        accepts: [
            { arg: 'id', type: 'string' },
            { arg: 'product', type: 'object', http: { source: 'body' } },
            { arg: 'req', type: 'object', http: { source: 'req' } }
        ],
        returns: [{ arg: 'cartCount', type: 'string' }],
        http: { verb: 'post', path: '/:id/addtocart' }
    });

    Customer.remoteMethod('editcart', {
        accepts: [
            { arg: 'id', type: 'string' },
            { arg: 'product', type: 'object', http: { source: 'body' } },
            { arg: 'req', type: 'object', http: { source: 'req' } }
        ],
        returns: [{ arg: 'cartCount', type: 'string' }],
        http: { verb: 'put', path: '/:id/editcart' }
    });

    Customer.remoteMethod('shopcartcount', {
        accepts: [
            { arg: 'id', type: 'string' },
            { arg: 'req', type: 'object', http: { source: 'req' } },
            { arg: 'ctx', type: 'object', http: { source: 'context' } }
        ],
        returns: [{ arg: 'count', type: 'number' }],
        http: { verb: 'get', path: '/:id/shopcartcount' },
    });

    Customer.remoteMethod('generatepayment', {
        accepts: [
            { arg: 'id', type: 'string' },
            { arg: 'req', type: 'object', http: { source: 'req' } },
            { arg: 'ctx', type: 'object', http: { source: 'context' } }
        ],
        returns: [{ arg: 'link', type: 'string' }],
        http: { verb: 'get', path: '/:id/generatepayment' },
    });
};