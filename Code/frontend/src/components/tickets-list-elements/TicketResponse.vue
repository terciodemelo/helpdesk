<template>
  <div class="ticket-response">
    <div class="box">
      <small>
        <strong> {{ response.author_name }} </strong>
        in
        <strong> 
          {{ response.created_at | moment("MMMM Do YYYY, hh:mm:ss") }}
        </strong>
      </small>
      <pre>{{ response.body }}</pre>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ticket-response',
  props: ['response']
}
</script>

<style scoped>
.box {
  padding-top: 3px;
}
pre {
  background-color: transparent;
}
</style>
