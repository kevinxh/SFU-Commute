import { assert, expect } from 'chai'
import request from 'request'
import app from '../'
import authTests from './auth';

process.env.NODE_ENV = 'development'

export default describe('Server', function () {

  let server = app

  before((done) => {
    server = server.listen(8008)
    done()
  })

  after((done) => {
    server.close()
    done()
  })

  it('simple test', (done) => {
    request.get('http://localhost:8008/', (err, res, body) => {
      expect(res.statusCode, 'Status code should be 200').to.equal(200)
      expect(body, 'Body should contain "SFU-Commute server!"').to
        .equal('SFU-Commute server!')
      done()
    })
  })

  authTests()
})
