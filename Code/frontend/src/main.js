// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import VueRouter from 'vue-router'
import VueResource from 'vue-resource'
import VueSweetAlert from 'vue-sweetalert'

import App from './App'
import Home from './components/Home'
import Tickets from './components/Tickets'
import TicketDetails from './components/TicketDetails'
import UsersList from './components/UsersList'
import UserDetails from './components/UserDetails'

import AuthHelper from './helpers/auth_helper'

import 'bulma/css/bulma.css'
import 'font-awesome/css/font-awesome.min.css'

Vue.use(require('vue-moment'))
Vue.use(VueSweetAlert)
Vue.use(VueResource)
Vue.use(VueRouter)

const router = new VueRouter({
  mode: 'history',
  routes: [
    {
      path: '/',
      component: Home,
      beforeEnter: (to, from, next) => {
        if (AuthHelper.isLoggedIn()) {
          next('/tickets')
        } else {
          next()
        }
      }
    },
    {
      path: '/tickets',
      component: Tickets,
      beforeEnter: (to, from, next) => {
        if (AuthHelper.isLoggedIn()) {
          next()
        } else {
          next('/')
        }
      }
    },
    {
      path: '/tickets/:id',
      component: TicketDetails
    },
    {
      path: '/users',
      component: UsersList,
      beforeEnter: (to, from, next) => {
        if (AuthHelper.isAdmin()) {
          next()
        } else {
          next('/')
        }
      }
    },
    {
      path: '/users/:id',
      component: UserDetails,
      beforeEnter: (to, from, next) => {
        if (AuthHelper.isAdmin()) {
          next()
        } else {
          next('/')
        }
      }
    }
  ]
})

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router: router,
  render: h => h(App)
})
