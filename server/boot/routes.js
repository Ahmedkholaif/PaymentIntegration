'use strict';

const cr = require('crypto');

module.exports = function (server) {
  // Install a `/` route that returns server status
  var router = server.loopback.Router();
  router.get('/', server.loopback.status());
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

    console.log(req.query);
    const val = cr.createHash('md5')
      .update(`ZjQ5ODM5MmEtMTExOC00NDY5LWFlZjgtMmZiODNjZTlhOTM4${sid}${order_number}${total}`)
      .digest('hex').toUpperCase();

    console.log({ val, key });

    if (key === val) {
      try {
        const bill = await Bill.findById(billid);
        if (bill.total === +total) {
          bill.status = 'done';
          await bill.save();
          const user = await Customer.findById(bill.customerId);
          user.shopCart = [];
          await user.save();
        }
      } catch (error) {
        console.log(error);
      }
    }
    debugger;
    res.redirect('http://localhost:3001/thanks');
  });
  server.use(router);
};
