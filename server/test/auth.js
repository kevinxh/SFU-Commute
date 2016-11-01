import { assert, expect } from 'chai'
import request from 'request'
import Chance from 'chance'
import User from '../model/user'

function generateTokenedRequestObject(token) {
  return request.defaults({
    headers: { Authorization: token }
  })
}

export default function () {
  // 1.
  describe('Authentication unit tests', function () {
    const chance = new Chance()
    const endPoints = {
      signup: 'http://localhost:8008/signup',
      signin: 'http://localhost:8008/signin',
      verifyText: 'http://localhost:8008/verify/text',
      verifyTextCode: 'http://localhost:8008/verify/text',
    }
    const fakeUser = {
      email: chance.email(),
      password: chance.string({length: 8}),
      firstname: chance.first(),
      lastname: chance.last()
    }
    let signUpAccessToken, signInAccessToken
    let tokenedRequestObject

    after((done) => {
      User.remove({ email: fakeUser.email }, () => {
        done()
      })
    })

    //1.1 ****************************Need to add firstname lastname tests.********************************
    describe('Sign Up', () => {

      //1.1.1
      it('without email or password', (done) => {
        request.post(endPoints.signup, {
          form: { email: '', password: '' , firstname: fakeUser.firstname, lastname: fakeUser.lastname}
        }, (err, resp, body) => {
          // more specific assertions!!!
          assert(JSON.parse(body).success === false,
          'Should return false')
          done()
        })
      })

      //1.1.2
      it('with invalid email form (eg. without "@")', (done) => {
        request.post(endPoints.signup, {
          form: { email: chance.string({length: 8}), password: 'abcdefgh' , firstname: fakeUser.firstname, lastname: fakeUser.lastname}
        }, (err, resp, body) => {
          assert(JSON.parse(body).error.errors.email.message === 'Please fill a valid e-mail address',
          'Should return "Please fill a valid e-mail address"')
          done()
        })
      })

      //1.1.3
      it('invalid password length (length < 6)', (done) => {
        request.post(endPoints.signup, {
          form: { email: 'test92748@gmail.com', password: chance.string({length: 5}) , firstname: fakeUser.firstname, lastname: fakeUser.lastname}
        }, (err, resp, body) => {
          assert(JSON.parse(body).error.errors.password.message === 'Password should be longer',
          'Should return "Password should be longer"')
          done()
        })
      })

      //1.1.4
      it('should succeed with valid email and valid password', (done) => {
        request.post(endPoints.signup, {
          form: {email:fakeUser.email, password: fakeUser.password , firstname: fakeUser.firstname, lastname: fakeUser.lastname}
        }, (err, resp, body) => {
          const parsedBody = JSON.parse(body);
          assert(parsedBody.success === true,
          `Should return true status and successfully register; ParsedBody = ${JSON.stringify(parsedBody)}`);
          expect(parsedBody, 'should have token').to.include.keys('access_token')
          signUpAccessToken = parsedBody.access_token
          tokenedRequestObject = generateTokenedRequestObject(signUpAccessToken)
          done()
        })
      })

      //1.1.5
      it('should fail registering when email is already in use', (done) => {
        request.post(endPoints.signup, {
          form: {email:fakeUser.email, password: fakeUser.password, firstname: fakeUser.firstname, lastname: fakeUser.lastname}
        }, (err, resp, body) => {
          assert(JSON.parse(body).success === false,
          'Should fail registering and success status == false')
          done()
        })
      })
    })

    //1.2
    describe('Sign In', () => {

      //1.2.1
      it('without email or password', (done) => {
        request.post(endPoints.signin, {
          form: { email: '', password: '' }
        }, (err, resp, body) => {
          assert(JSON.parse(body).error === 'Please enter your email and password.',
          'Should return "Please enter your email and password."')
          done()
        })
      })

      //1.2.2
      it('with nonexisting user', (done) => {
        request.post(endPoints.signin, {
          form: { email: chance.email(), password: 'abcdefg' }
        }, (err, resp, body) => {
          assert(JSON.parse(body).error === 'Authentication failed. User not found.',
          'Should return "Authentication failed. User not found."')
          done()
        })
      })

      //1.2.3
      it('with existing user but wrong password', (done) => {
        request.post(endPoints.signin, {
          form: {
            email: fakeUser.email,
            // TODO: Replace the string here with a GUID generated string
            password: 'Guaranteed1WrongPW'
          }
        }, (err, resp, body) => {
          assert(JSON.parse(body).error === 'Authentication failed. Passwords does not match.',
          'Should return "Authentication failed. Passwords does not match."')
          done()
        })
      })

      //1.2.4
      it('with correct authentication information', (done) => {
        request.post(endPoints.signin, {
          form: {email:fakeUser.email, password: fakeUser.password}
        }, (err, resp, body) => {
          const parsedBody = JSON.parse(body);
          assert(parsedBody.success === true, 'Should return true status')
          assert(parsedBody.user.email === fakeUser.email,
            'Should contain registered email')
          expect(parsedBody, 'Should include access token').to.include.keys('access_token')
          done()
        })
      })
    })

    //1.3
    describe('Send verification text code', () =>{
      let fakePhone = chance.natural({min: 10000000000, max: 99999999999})
      let code

      //1.3.1
      it('without access_token', (done) => {
        request.post(endPoints.verifyText, {
          form: { phone: '17781231234' }
        }, (err, resp, body) => {
          assert(JSON.parse(body).error === 'Error: The request is missing correct access token.',
          'Should return "Error: The request is missing correct access token."')
          done()
        })
      })

      //1.3.2
      it('with invalid phone number', (done) => {
        tokenedRequestObject.post(endPoints.verifyText, {
          form: { phone: '123456' }
        }, (err, resp, body) => {
          assert(JSON.parse(body).error === 'Missing parameter:  11-digit phone number.',
          'Should return "Missing parameter:  11-digit phone number."')
          done()
        })
      })

      //1.3.3
      it('with valid phone number and access token', (done) => {
        tokenedRequestObject.post(endPoints.verifyText, {
          form: { phone: fakePhone, env:'unitTest'}
        }, (err, resp, body) => {
          assert(JSON.parse(body).success === true, 'Should return true status')
          assert(JSON.parse(body).msg === 'unit-test success.', 'Should return "unit-test success."')
          assert(JSON.parse(body).user.phone.number == fakePhone,
          `Should return "${fakePhone}"`)
          expect(JSON.parse(body).user.phone.verification, 'Should include phone verification code').to.include.keys('code')
          code = JSON.parse(body).user.phone.verification.code
          done()
        })
      })

      //1.3.4
      it('with invalid code', (done) => {
        tokenedRequestObject.get(endPoints.verifyTextCode, {
          qs: { code: '12345'}
        }, (err, resp, body) => {
          assert(JSON.parse(body).success === false, 'Should return false status')
          assert(JSON.parse(body).error === 'Missing parameter: 4-digit verfication code.', 'Should return "Missing parameter: 4-digit verfication code."')
          done()
        })
      })

      //1.3.5
      it('with incorrect code', (done) => {
        tokenedRequestObject.get(endPoints.verifyTextCode, {
          qs: { code: '1234'}
        }, (err, resp, body) => {
          assert(JSON.parse(body).success === false, 'Should return false status')
          assert(JSON.parse(body).error === 'The code is incorrect.', 'Should return "The code is incorrect."')
          done()
        })
      })

      //1.3.6
      it('with correct code', (done) => {
        tokenedRequestObject.get(endPoints.verifyTextCode, {
          qs: { code }
        }, (err, resp, body) => {
          assert(JSON.parse(body).success === true, 'Should return false status')
          assert(JSON.parse(body).msg === 'Phone number successfully verified!', 'Should return "Phone number successfully verified!"')
          done()
        })
      })
    })
  })
}
