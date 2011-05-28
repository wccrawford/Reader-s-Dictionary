import "android.app.Activity"
import "android.os.Bundle"
import "android.widget.TextView"
import "android.content.Context"
import "Layout", "com.kelahn.readersdictionary.R$layout"

class ReadersDictionary < Activity
  def onCreate(savedInstanceState:Bundle)
    super(savedInstanceState)
    setContentView(Layout.main)
  end
end
