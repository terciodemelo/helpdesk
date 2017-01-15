<template>
  <div class="form-footer">
    <a class="button">{{ button }}</a>
    <div id="form-footer-links">
      <a href="" @click.prevent="followLink">{{ link }}</a>
    </div>
  </div>
</template>

<script>
export default {
  name: 'form-footer',
  props: ['button', 'link'],
  methods: {
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
