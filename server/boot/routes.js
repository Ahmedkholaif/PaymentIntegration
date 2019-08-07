'use strict';

const cr = require('crypto');

module.exports = function (server) {
  // Install a `/` route that returns server status
  var router = server.loopback.Router();
  router.post('/checkout_reply', (req, res) => {

    const { body, headers, query, params } = req;
    const { order_number, key } = req;

    console.log({ order_number, key });
    console.log('======================')
    console.log({ body, headers, query, params });
    console.log({ req })
    res.json('hello post');
  });

  router.get('/checkout_reply', async (req, res) => {
    const Bill = server.models.Bill;
    const Customer = server.models.Customer;
    const { key, total, sid, order_number, billid, userid } = req.query;
    const {secret} = require('../config');

    const val = cr.createHash('md5')
      .update(`${secret}${sid}${order_number}${total}`)
      .digest('hex').toUpperCase();

    if (key === val) { 
      try {
        const bill = await Bill.findById(billid);
        if (bill.total === +total) {
          bill.status = 'done';
          await bill.save();
          const user = await Customer.findById(bill.customerId);
          user.shopCart = [];
          await user.save();
          res.redirect('http://localhost:3001/thanks');
        }
      } catch (error) {
        console.log(error);
      }
    }
    res.redirect('http://localhost:3001/error');
    debugger;
  });
  server.use(router);
};
