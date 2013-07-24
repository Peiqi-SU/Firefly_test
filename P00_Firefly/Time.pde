import java.sql.Timestamp;
import java.util.Date;
import java.text.SimpleDateFormat;

String get_current_time(){
      java.util.Date date = new java.util.Date();
      SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH-mm-ss.SSS") ;
      return dateFormat.format(date);
}
