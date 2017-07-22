//=====================================================================
//
//  File:    SqlJonMon.java  
//  Summary: NAGIOS plugin to determine recent and history SQL Server Agent Job failures 
//           current date.
//  Date:    July 2010
//
//===================================================================== 

import java.sql.*;
import java.io.*;
import java.util.Date;
import java.util.Properties;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

public class SqlJobMon {

	public static void main(String[] args) {

		int count = 0;
		String connectionUrl;
		String datetime;
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		FileOutputStream out = null; // declare a file output object
		PrintStream p = null; // declare a print stream object
		datetime = dateFormat.format(date);

		String style = "<style type=\"text/css\"> #gradient-style"
				+ "{"
				+ "	font-family: \"Lucida Sans Unicode\", \"Lucida Grande\", Sans-Serif;"
				+ "font-size: 12px;"
				+ "margin: 0px;"
				+ "width: 1000px;"
				+ "text-align: left;"
				+ "border-collapse: collapse;"
				+ "}"
				+ "#gradient-style th"
				+ "{"
				+ "font-size: 13px;"
				+ "font-weight: normal;"
				+ "padding: 8px;"
				+ "background: #b9c9fe;"
				+ "border-top: 2px solid #d3ddff;"
				+ "border-bottom: 1px solid #fff;"
				+ "color: #039;"
				+ "}"
				+ "#gradient-style td"
				+ "{"
				+ "padding: 8px;"
				+ "border-bottom: 1px solid #fff;"
				+ "color: #669;"
				+ "border-top: 1px solid #fff;"
				+ "background: #e8edff;"
				+ "}"
				+ "#gradient-style tfoot tr td"
				+ "{"
				+ "background: #e8edff;"
				+ "font-size: 12px;"
				+ "color: #99c;"
				+ "}"
				+ "#gradient-style tbody tr:hover td"
				+ "{"
				+ "background: #d0dafd;"
				+ "color: #339;"
				+ "}"
				+ "#gradient-style caption"
				+ "{"
				+ "font-family: \"Lucida Sans Unicode\", \"Lucida Grande\", Sans-Serif; font-weight: bold; font-size: 13px;color: #039;"
				+ "}</style>";

		connectionUrl = "jdbc:sqlserver://" + args[0]
				+ ":1433;databaseName=msdb;integratedSecurity=false;user="
				+ args[1] + ";password=" + args[2];

		// Declare the JDBC objects.
		Connection con = null;
		Statement stmt = null;
		ResultSet rsHistory = null, rsRecent = null;

		try {
			// Reading values from property file
			String link = new SqlJobMon().readPropertiesFile("HTML_LINK");
			String currentDirectory = new SqlJobMon()
					.readPropertiesFile("HTML_DIR");
			File file = new File(currentDirectory + "sqllog");
			boolean exist = file.exists();
			if (!exist) {
				boolean success = (new File(currentDirectory + "sqllog"))
						.mkdir();
			}
			out = new FileOutputStream(currentDirectory + "sqllog/" + args[0]
					+ "-" + datetime + ".html");
			p = new PrintStream(out);
			// Establish the connection.
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
			con = DriverManager.getConnection(connectionUrl);

			// Create and execute an SQL statement For getting history and
			// recent job failed.

			String sqlHistory = "select sj.name, sjh.step_name, sjh.run_date, sjh.run_time, sjh.run_status, sjh.message, sjh.server "
					+ "from msdb.dbo.sysjobhistory sjh inner join msdb.dbo.sysjobs sj on sjh.job_id = sj.job_id "
					+ "inner join msdb.dbo.sysjobsteps sjs on sj.job_id = sjs.job_id and sjh.step_id = sjs.step_id "
					+ "where sjh.run_status = 0";

			stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
			rsHistory = stmt.executeQuery(sqlHistory);

			String sqlRecent = "select sj.name, sjh.step_name, sjh.run_date, sjh.run_time, sjh.run_status, sjh.message, sjh.server "
					+ "from msdb.dbo.sysjobhistory sjh inner join msdb.dbo.sysjobs sj on sjh.job_id = sj.job_id "
					+ "inner join msdb.dbo.sysjobsteps sjs on sj.job_id = sjs.job_id and sjh.step_id = sjs.step_id "
					+ "where sjh.run_status = 0 and sjh.run_date in (select MAX(sjh.run_date) "
					+ "from msdb.dbo.sysjobhistory sjh "
					+ "where sjh.run_status = 0 group by sjh.job_id,sjh.run_status)and sjh.run_time in "
					+ "(select MAX(sjh.run_time) from msdb.dbo.sysjobhistory sjh where sjh.run_status = 0 group by sjh.job_id,sjh.run_status)";
			stmt = null;
			stmt = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
					ResultSet.CONCUR_READ_ONLY);
			rsRecent = stmt.executeQuery(sqlRecent);

			while (rsRecent.next()) {
				count++;
			}
			rsRecent.beforeFirst();

			if (count > 0) {
				p
						.println("<html>\n<head>"
								+ style
								+ "<title>Failed SQL Job </title>"
								+ "</head><table border=1 id=\"gradient-style\">\n<CAPTION>Recent SQL Job Failed For Current Date "
								+ datetime
								+ "</CAPTION>\n"
								+ "<th>Date</th>\n<th>Time</th>\n<th>Server</th>\n<th>Job_Name</th>\n<th>Step_Name</th>\n<th>Run_Status"
								+ "</th>\n<th>Message</th>\n");
				// Iterate through the data in the result set and display it.
				while (rsRecent.next()) {
					p.println("<tr>");
					p.print("<td>");
					p.print(rsRecent.getString("run_date"));
					p.print("</td>\n");
					p.print("<td>");
					p.print(rsRecent.getString("run_time"));
					p.print("</td>\n");
					p.print("<td>");
					p.print(rsRecent.getString("server"));
					p.print("</td>\n");
					p.print("<td>");
					p.print(rsRecent.getString("name"));
					p.print("</td>\n");
					p.print("<td>");
					p.print(rsRecent.getString("step_name"));
					p.print("</td>\n");
					p.print("<td>");
					p.print(rsRecent.getString("run_status"));
					p.print("</td>\n");
					p.print("<td>");
					p.print(rsRecent.getString("message"));
					p.print("</td>\n");
					p.println("</tr>");
				}
				p.println("</table>");
				p.println("<a href=JavaScript:history.back();>[ back ]</a>");
				System.out.print("<a href=" + link + "/" + args[0] + "-"
						+ datetime + ".html target=main>");
				System.out.print(" CRITICAL: Number of Jobs Failed:" + count
						+ "|count=" + count);
				System.out.print("</a>\n");
			}

			if (count == 0) {

				p
						.println("<html>\n<head>"
								+ style
								+ "<title>Failed SQL Job </title>"
								+ "</head><table border=1 id=\"gradient-style\">\n<CAPTION>Recent SQL Job Failed For Current Date "
								+ datetime
								+ "</CAPTION>\n"
								+ "<th>Date</th>\n<th>Time</th>\n<th>Server</th>\n<th>Job_Name</th>\n<th>Step_Name</th>\n<th>Run_Status"
								+ "</th>\n<th>Message</th>\n");

				System.out.print("<a href=" + link + "/" + args[0] + "-"
						+ datetime + ".html target=main>");
				System.out.print(" OK: Number of Jobs Failed:" + count
						+ "|count=" + count);
				System.out.print("</a>\n");
				System.out.flush();
				p.println("No Failed Jobs");
				p.println("</table>");
				p.println("<a href=JavaScript:history.back();>[ back ]</a>");

			}

			count = 0;

			while (rsHistory.next()) {
				count++;
			}
			rsHistory.beforeFirst();

			if (count > 0) {

				p
						.println("<table border=1 id=\"gradient-style\">\n<CAPTION>History SQL Job Failed For Current Date "
								+ datetime
								+ " </CAPTION>\n"
								+ "<th>Date</th>\n<th>Time</th>\n<th>Server</th>\n<th>Job_Name</th>\n<th>Step_Name</th>\n<th>Run_Status"
								+ "</th>\n<th>Message</th>\n");
				// Iterate through the data in the result set and display it.
				while (rsHistory.next()) {
					p.println("<tr>");
					p.print("<td>");
					p.print(rsHistory.getString("run_date"));
					p.print("</td>\n");
					p.print("<td>");
					p.print(rsHistory.getString("run_time"));
					p.print("</td>\n");
					p.print("<td>");
					p.print(rsHistory.getString("server"));
					p.print("</td>\n");
					p.print("<td>");
					p.print(rsHistory.getString("name"));
					p.print("</td>\n");
					p.print("<td>");
					p.print(rsHistory.getString("step_name"));
					p.print("</td>\n");
					p.print("<td>");
					p.print(rsHistory.getString("run_status"));
					p.print("</td>\n");
					p.print("<td>");
					p.print(rsHistory.getString("message"));
					p.print("</td>\n");
					p.println("</tr>");
				}
				p.println("</table>");
				p.println("<a href=JavaScript:history.back();>[ back ]</a>");
				p.println("</html>");

			}
			if (count == 0) {

				p
						.println("<table border=1>\n<CAPTION>History SQL Job Failed For Current Date "
								+ datetime
								+ " </CAPTION>\n"
								+ "<th>Date</th>\n<th>Time</th>\n<th>Server</th>\n<th>Job_Name</th>\n<th>Step_Name</th>\n<th>Run_Status"
								+ "</th>\n<th>Message</th>\n");

				p.println("No Failed Jobs");
				p.println("</table>");
				p.println("<a href=JavaScript:history.back();>[ back ]</a>");
				p.println("</html>");

			}
		}

		// Handle any errors that may have occurred.
		catch (Exception e) {
			e.printStackTrace();
		}

		finally {
			if (out != null)
				try {
					p.close();
					out.close();
				} catch (Exception e) {
				}
			if (rsRecent != null)
				try {
					rsRecent.close();
				} catch (Exception e) {
				}

			if (rsHistory != null)
				try {
					rsHistory.close();
				} catch (Exception e) {
				}
			if (stmt != null)
				try {
					stmt.close();
				} catch (Exception e) {
				}
			if (con != null)
				try {
					con.close();
				} catch (Exception e) {
				}

		}
	}

	/*
	 * To read the property file and return the value for key which is stored in
	 * the property file
	 */
	public String readPropertiesFile(String key) {
		String value = null;
		try {
			String path = null;
			Properties prop = new Properties();
			File dir1 = new File(".");
			/* To get the current working directory */
			path = dir1.getCanonicalPath();
			prop.load(new FileInputStream(path + "/url.properties"));
			value = prop.getProperty(key);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return value;
	}
}
