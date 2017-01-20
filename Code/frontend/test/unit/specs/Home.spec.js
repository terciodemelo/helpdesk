import Vue from 'vue'
import Home from 'src/components/Home'

describe('Home.vue', function () {
  before(() => {
    this.vm = new Vue({
      el: document.createElement('div'),
      render: h => h(Home)
    })
  })

  context('displayed elements', () => {
    it('should display a welcome message', () => {
      expect(this.vm.$el.querySelector('.home h1').textContent)
        .to.equal('Welcome to Customer Support')
    })

    it('should display a welcome message in a div.content', () => {
      let classList = this.vm.$el.querySelector('#welcome-message').classList
      expect(classList.contains('content')).to.equal(true)
    })

    it('should display a login form', () => {
      let loginForm = this.vm.$el.querySelector('.login-form')
      expect(loginForm).to.not.equal(null)
    })
  })

  context('component data', function() {
    it ('data should be a function', () => {
      expect(typeof Home.data).to.equal('function')
    })

    context('default data', function() {
      before(() => {
        this.defaultData = Home.data()
      })

      it('should have a \'form\' attribute', () => {
        expect(this.defaultData).to.have.property('form')
      })

      it('\'form\' attribute should have default value \'login\'', () => {
        expect(this.defaultData.form).to.equal('login')
      })
    })
  })
})
