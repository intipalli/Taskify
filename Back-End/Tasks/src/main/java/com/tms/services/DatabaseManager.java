package com.tms.services;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseManager {

	private static Connection conn;

	// Method to establish a database connection
	private static void setConnection() {

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");

			String url = "jdbc:mysql://localhost:3306/taskmanagementsystem" + "?useSSL=false"
					+ "&useLegacyDatetimeCode=false" + "&serverTimezone=UTC" + "&allowPublicKeyRetrieval=true";
			String username = "root";
			String password = "Admin@2001";

			conn = DriverManager.getConnection(url, username, password);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public static Connection getConnection() throws SQLException {
		if (conn == null || conn.isClosed()) {
			setConnection();
		}
		return conn;
	}

	public void closeConnection() {
		if (conn != null) {
			try {
				conn.close();
				System.out.println("Database connection closed");
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				conn = null; // Ensure conn is set to null after closing
			}
		}
	}
}
