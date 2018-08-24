const express = require('express')
const fetch = require('node-fetch')
const router = express.Router()

class Service {
  constructor (name, url) {
    this.name = name
    this.url = url
  }

  toString () {
    return `${this.name} (${this.url})`
  }
}

const services = [
  new Service('Go', 'https://httpstat.us/200?sleep=2000'),
  new Service('Spring', 'https://httpstatus.us/500')
]

function formatDuration (compareDate) {
  const duration = Math.abs(new Date() - compareDate)
  return `${duration} ms`
}

function fetchStatus (service) {
  const measureStart = new Date()
  console.log(`Fetch for ${service} started at ${measureStart}`)
  return fetch(service.url, {
    timeout: 5000
    // headers: {'Content-Type': 'application/json'}
  }).then(res => `${service} is ${res.statusText} (${formatDuration(measureStart)})`)
    .catch(error => {
      console.error(`Fetch for ${service} failed (${error.code})`)
      // return Promise.reject(Error(`error: ${body}`))
      return `${service} is UNAVAILABLE (${formatDuration(measureStart)})`
    })
    .then(res => {
      console.log(`Fetch for ${service} completed in ${formatDuration(measureStart)}`)
      return res
    })
}

router.get('/', (req, res, next) => {
  const serviceStatusPromises = services.map(service => {
    console.log(`Will fetch status for ${service}`)
    return fetchStatus(service)
  })

  Promise.all(serviceStatusPromises)
    .then(function (values) {
      res.render('index', {services: values})
    })
    .catch(error => {
      console.log(error)
      res.render(`error: ${error}`)
    })
})

module.exports = router
