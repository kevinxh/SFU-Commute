import Nexmo from 'nexmo'
import config from './secret'

var nexmo = new Nexmo({
	apiKey: config.nexmoApiKey,
	apiSecret: config.nexmoApiSecret,
})

export default nexmo