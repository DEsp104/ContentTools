class TimeTool extends ContentTools.Tools.Bold
 ContentTools.ToolShelf.stow(@, 'time')
 @label = 'Time'
 @icon = 'time'

 @tagName = 'time'
 
 @apply: (element, selection, callback) ->
 element.storeState()

 selectTag = new HTMLString.Tag('span', {'class': 'ct--puesdo-select'})
 [from, to] = selection.get()
 element.content = element.content.format(from, to, selectTag)
 element.updateInnerHTML()

 app = ContentTools.EditorApp.get()

 modal = new ContentTools.ModalUI(transparent=true, allowScrolling=true)

 modal.addEventListener 'click', () ->
# Close the dialog
        @unmount()
        dialog.hide()

        # Remove the fake selection from the element
        element.content = element.content.unformat(from, to, selectTag)
        element.updateInnerHTML()

        # Restore the real selection
        element.restoreState()

        # Trigger the callback
        callback(false)


  domElement = element.domElement()
  measureSpan = domElement.getElementsByClassName('ct--puesdo-select')
  rect = measureSpan[0].getBoundingClientRect()

  dialog = new TimeDialog(@getDatetime(element, selection))
  dialog.position([rect.left + (rect.width / 2) + window.scrollX,rect.top + (rect.height / 2) + window.scrollY])

  dialog.addEventListener 'save', (ev) -> datetime = ev.detail().datetime

  element.content = element.content.unformat(from, to, 'time')

  if datetime
            time = new HTMLString.Tag('time', {datetime: datetime})
            element.content = element.content.format(from, to, time)

        element.updateInnerHTML()
        element.taint()

        # Close the modal and dialog
        modal.unmount()
        dialog.hide()

        # Remove the fake selection from the element
        element.content = element.content.unformat(from, to, selectTag)
        element.updateInnerHTML()

        # Restore the real selection
        element.restoreState()

        # Trigger the callback
        callback(true)

    app.attach(modal)
    app.attach(dialog)
    modal.show()
    dialog.show()

 
 @getDatetime: (element, selection) ->
       [from, to] = selection.get()
       selectedContent = element.content.slice(from, to)
       for c in selectedContent.characters
        if not c.hasTags('time')
            continue
        for tag in c.tags()
            if tag.name() == 'a'
                return tag.attr('href')

        return ''  


class TimeDialog extends ContentTools.LinkDialog

    # An anchored dialog to support inserting/modifying a <time> tag

    mount: () ->
        super()

        # Update the name and placeholder for the input field provided by the
        # link dialog.
        @_domInput.setAttribute('name', 'time')
        @_domInput.setAttribute('placeholder', 'Enter a date/time/duration...')

        # Remove the new window target DOM element
        @_domElement.removeChild(@_domTargetButton);

    save: () ->
        # Save the datetime.
        detail = {
            datetime: @_domInput.value.trim()
        }
        @dispatchEvent(@createEvent('save', detail))


ContentTools.DEFAULT_TOOLS[0].push('time')
