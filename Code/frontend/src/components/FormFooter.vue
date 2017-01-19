<template>
  <div class="form-footer">
    <button class="button is-primary" @click.prevent="buttonClick">
      {{ button }}
    </button>

    <div id="form-footer-links">
      <a href="" @click.prevent="followLink">{{ link }}</a>
    </div>
  </div>
</template>

<script>
export default {
  name: 'form-footer',

  /*
   * 'button' prop simply stores the text to be displayed in the button
   * 'link' prop simply stores the text to be displayed in the link
   */
  props: ['button', 'link'],
  methods: {
    /*
     * Triggered when the button is clicked, then it emmits a 'button-click'
     * event which shall be handled by the enclosing component
     */
    buttonClick () {
      this.$emit('button-click')
    },

    /*
     * Triggered when the link is clicked, then it emmits a 'follow-link'
     * event which shall be handled by the enclosing component
     */
    followLink () {
      this.$emit('follow-link')
    }
  }
}
</script>

<style scoped>
.form-footer {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
}

#form-footer-links {
  display: flex;
  flex-direction: column;
  font-size: small;
}
</style>
