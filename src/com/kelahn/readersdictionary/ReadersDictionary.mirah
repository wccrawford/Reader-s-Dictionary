import "android.app.Activity"
import "android.os.Bundle"
import "android.widget.TextView"
import "android.widget.Button"
import "android.widget.EditText"
import "android.view.KeyEvent"
import "android.view.View"
import "android.view.View.OnClickListener"
import "android.view.View.OnKeyListener"
import "android.content.Context"
import "Layout", "com.kelahn.readersdictionary.R$layout"

class ReadersDictionary < Activity
	implements OnClickListener
	implements OnKeyListener
	def onCreate(savedInstanceState:Bundle)
		super(savedInstanceState)
		setContentView(Layout.main)

		searchButton = Button(findViewById R.id.button1)
		searchButton.setOnClickListener self
		
		searchEdit = EditText(findViewById R.id.EditText01)
		searchEdit.setOnKeyListener self
	end
	
	def onClick(v:View)
		lookupWord
	end

	def onKey(v:View, keyCode:int, event:KeyEvent)
		if(event.getAction == KeyEvent.ACTION_DOWN &&
				keyCode == KeyEvent.KEYCODE_ENTER) then
			lookupWord
			return true
		end

		return false
	end

	def lookupWord
		searchEdit = EditText(findViewById R.id.EditText01)
		searchEdit.selectAll

		displayText = TextView(findViewById R.id.textView1)

		displayText.append(searchEdit.getText)
	end
end
