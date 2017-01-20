import Vue from 'vue'
import App from 'src/App'

describe('App.vue', function () {
  before(() => {
    this.vm = new Vue({
      el: document.createElement('div'),
      render: h => h(App)
    })
  })

  context('displayed elements', () => {
    it('should display a nav bar', () => {
      expect(this.vm.$el.querySelector('nav'))
        .to.not.equal(null)
    })

    context('nav bar', () => {
      before(() => {
        this.classList = this.vm.$el.querySelector('nav').classList
      })

      it('should have two classes', () => {
        expect(this.classList.length).to.equal(2)
      })

      it('should have class \'nav\'', () => {
        expect(this.classList.contains('nav')).to.equal(true)
      })

      it('should have class \'has-shadow\'', () => {
        expect(this.classList.contains('has-shadow')).to.equal(true)
      })

      it('should have a .nav-left child', () => {
        let navLeft = this.vm.$el.querySelector('nav > .nav-left')
        expect(navLeft).to.not.equal(null)
      })

      it('should have 2 .nav-item grandchildren from .nav-left', () => {
        let items = this.vm.$el.querySelectorAll('nav > .nav-left > .nav-item')
        expect(items).to.have.lengthOf(2)
      })
    })
  })
})
