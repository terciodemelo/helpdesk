<template>
  <div class="ticket-response">
    <div class="box" :class="getStyle()">
      <small>
        <strong id="name"> {{ response.author_name }} </strong>
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
import AuthHelper from '../../helpers/auth_helper'

export default {
  name: 'ticket-response',
  /*
   * Stores a response data to be displayed by this component
   */
  props: ['response'],
  methods: {
    /*
     * Returns a CSS class according to the authory of the current
     * response.
     *
     * @return [String] 'user-response' if the currently logged in user
     *                  is the response author, 'other-response' otherwise
     */
    getStyle () {
      return this.response.author_id === +AuthHelper.user().id
             ? 'user-response' : 'other-response'
    }
  }
}
</script>

<style scoped>
.box {
  padding-top: 3px;
}

.other-response {
  border-radius: 0px 5px 5px 5px;
  position:relative;
  margin-left: 13px;
}
.other-response:after {
  content: '';
  position: absolute;
  border-style: solid;
  border-width: 0 13px 15px 0;
  border-color: transparent #FFFFFF;
  display: block;
  width: 0;
  z-index: 1;
  left: -11px;
  top: -0px;
}

.other-response:before {
  content: '';
  position: absolute;
  border-style: solid;
  border-width: 0 13px 15px 0;
  border-color: transparent #dfdfdf;
  display: block;
  width: 0;
  z-index: 0;
  left: -13px;
  top: -1px;
}

.user-response {
  border-radius: 5px 0px 5px 5px;
  position:relative;
  margin-right: 13px;
}

.user-response:after {
  content: '';
  position: absolute;
  border-style: solid;
  border-width: 0 0 15px 13px;
  border-color: transparent #FFFFFF;
  display: block;
  width: 0;
  z-index: 1;
  right: -11px;
  top: -0px;
}

.user-response:before {
  content: '';
  position: absolute;
  border-style: solid;
  border-width: 0 0 15px 13px;
  border-color: transparent #dfdfdf;
  display: block;
  width: 0;
  z-index: 0;
  right: -13px;
  top: -1px;
}

.user-response #name {
  color: dodgerblue;
}

#name {
  color: cornflowerblue;
}

pre {
  background-color: transparent;
}
</style>
