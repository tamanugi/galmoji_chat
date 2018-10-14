<template lang="pug">
.chat
  .board
    .messages_wrapper
      .scroll_wrap
        .messages
          .message(v-for="messageObj in messages")
            .header
              .avatar
                .image
              .meta
                span.username {{messageObj.username}}
                time.timestamp {{messageObj.posted_at}}
            .content
              .markup {{messageObj.message}}
    .message_form_wrapper
      input.input_username(type=text, v-model="input_username")
      input.input_message(type=text, v-model="input_message", @keydown="shoutMessage")
  .members
</template>

<script>
import { Socket } from '../static/phoenix'

export default {
  name: 'App',
  data: function () {
    return {
      channel: {},
      messages: [],
      input_username: '',
      input_message: ''
    }
  },
  methods: {
    shoutMessage: function (event) {
      if (event.keyCode !== 13) {
        return
      }
      console.log(this.input_message)
      if (this.input_message) {
        let username = this.input_username || 'ギャル'
        this.channel.push('shout', {username: username, message: this.input_message})
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
      this.messages.push(payload)
    })

    channel.join()

    this.channel = channel
  }
}
</script>

<style lang="stylus">
.chat
  background-color #36393f
  display flex
  flex 1 1 auto
  flex-direction row
  color #ffffff
  margin 0 auto

.board
  display flex
  flex-direction column
  flex 1

.messages_wrapper
  display flex
  flex 1
  overflow hidden
  position relative
  z-index 0

  .scroll_wrap
    width 100%

.message
  margin-bottom .2em

  .header
    -webkit-box-align start
    align-content normal
    align-items flex-start
    display -webkit-box
    display -ms-flexbox
    display flex
    height 1.3em

    .meta
      .username
        font-weight bold

      .timestamp
        margin-left 5px
        font-size .6rem

    .avatar
      cursor pointer
      margin -2px 20px 20px
      opacity 1
      transition opacity .2s ease

      .image
        background-clip padding-box
        background-color #ffffff
        background-image url('./assets/ganguro_gal.png')
        background-position: 50%;
        background-size: 100%;
        border-radius 50%
        height: 40px;
        width: 40px;

  .content
    margin-left 80px
    font-size .9em
    line-height 1.3
    user-select text
    white-space pre-wrap
    word-wrap break-word
</style>
