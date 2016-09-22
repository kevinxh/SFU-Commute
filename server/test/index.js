import { assert, expect } from 'chai'
import request from 'request'
import app from '../'

process.env.NODE_ENV = 'test'

export default describe('Server unit tests', function () {

  let server = app

  before((done) => {
    server = server.listen(3000)
    done()
  })

  after((done) => {
    server.close()
    done()
  })

  it('simple test', (done) => {
    request.get('http://localhost:3000/', (err, res, body) => {
      expect(res.statusCode, 'Status code should be 200').to.equal(200)
      expect(body, 'Body should contain "Initialize SFU-Commute backend server!"').to
        .equal('Initialize SFU-Commute backend server!')
      done()
    })
  })
})
