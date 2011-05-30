import "android.app.Activity"
import "android.os.Bundle"
import "android.widget.TextView"
import "android.widget.Button"
import "android.widget.EditText"
import "android.view.KeyEvent"
import "android.view.View"
import "android.view.View.OnClickListener"
import "android.view.View.OnKeyListener"
import "android.database.DatabaseUtils"
import "android.content.Context"
import "android.database.sqlite.SQLiteDatabase"
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

		databaseLocation = '/data/data/com.kelahn.readersdictionary/databases/dictionary.db'

		@dictionary = SQLiteDatabase.openDatabase(databaseLocation, null, SQLiteDatabase.OPEN_READONLY | SQLiteDatabase.NO_LOCALIZED_COLLATORS)
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

		# Can't use proper paramterization thanks to a long-standing Android bug.
		escapedWord = DatabaseUtils.sqlEscapeString(searchEdit.getText.toString)
		# Trim the ' from each side
		escapedWord = escapedWord.substring(1, escapedWord.length-1)
		unless escapedWord == '' then
			cursor = @dictionary.rawQuery("SELECT word, pronunciation, translation FROM dictionary where word like '%" + escapedWord +  "%' or pronunciation like '%" + escapedWord +  "%' order by word;", null)
			cursor.moveToFirst
			until cursor.isAfterLast do
				word = cursor.getString(cursor.getColumnIndex('word'))
				pronunciation = cursor.getString(cursor.getColumnIndex('pronunciation'))
				translation = cursor.getString(cursor.getColumnIndex('translation'))
				displayText.append word unless word == nil
				displayText.append(" - " + pronunciation) unless pronunciation == nil
				displayText.append(" - " + translation) unless translation == nil
				displayText.append("\n\n")
				cursor.moveToNext
			end
			cursor.close
		end
	end
end
