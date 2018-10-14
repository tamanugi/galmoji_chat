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
      .message_form
        .inner.flex
          textarea.input_message(rows=1, v-model="input_message", @keydown.enter="shoutMessage",
                                 style="height: auto;")
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
    shoutMessage: function (e) {
      if (e.target.value !== this.input_message ) {
        return
      }

      if (e.shiftKey) {
        return
      }

      if (this.input_message) {
        e.stopPropagation()
        e.preventDefault()
        e.returnValue = false

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
.flex
  display flex

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

.message_form_wrapper
  border-top 1px solid hsla(0,0%,100%,.06)
  margin-bottom 30px
  padding-top 20px
  position relative
  transition opacity .2s ease
  flex-shrink: 0;
  margin-left: 20px;
  margin-right: 20px;

  .message_form
    height 0
    position relative

    .inner
      background-color: rgba(114,118,125,.3)
      border-radius 5px

      .input_message
        color hsla(0,0%,100%,.7)
        background-color transparent
        border none
        font-size 0.9375rem
        font-weight 400
        letter-spacing -0.025rem
        line-height 1.25rem
        margin 2px 2px 2px 0
        max-height 144px
        min-height 20px
        padding 10px 38px 10px 10px
        resize none
        width 100%

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
