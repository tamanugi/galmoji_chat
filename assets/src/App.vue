<template lang="pug">
#app
  .message_board
    .message(v-for="message in messages")
      span {{message}}
  .message_form_wrapper
    input(type=text, v-model="input_message")
    button(@click="shoutMessage") 送信
</template>

<script>
import { Socket } from '../static/phoenix'

export default {
  name: 'App',
  data: function () {
    return {
      channel: {},
      messages: ['hoge', 'hoge2'],
      input_message: ''
    }
  },
  methods: {
    shoutMessage: function () {
      console.log(this.input_message)
      if (this.input_message) {
        this.channel.push('shout', {message: this.input_message})
        this.input_message = ''
      }
    }
  },
  mounted: function () {
    let socket = new Socket('ws://localhost:4000/socket')
    socket.connect()
    let channel = socket.channel('room:lobby', {})

    channel.on('shout', payload => {
      console.log(payload)
      this.messages.push(payload.message)
    })

    channel.join()

    this.channel = channel
  }
}
</script>

<style lang="stylus">
#app
  font-family 'Avenir', Helvetica, Arial, sans-serif
  -webkit-font-smoothing antialiased
  -moz-osx-font-smoothing grayscale
  text-align center
  color #2c3e50
  margin-top 60px
</style>
