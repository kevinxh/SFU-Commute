import nodemailer from 'nodemailer'
import config from './secret'

const emailTransporter = nodemailer.createTransport(config.smtpConfig)
export default emailTransporter