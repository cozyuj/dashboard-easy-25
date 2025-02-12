<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.json.simple.*"%>
<%@ include file="./common/dbcon.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setCharacterEncoding("UTF-8");

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    JSONObject responseObj = new JSONObject();
    JSONObject orgInfoObj = new JSONObject();
    JSONArray devicesArray = new JSONArray();

    // 조직 정보 가져오기
    String orgInfoString = "SELECT orgName FROM org_info WHERE orgID = 22";
    pstmt = con.prepareStatement(orgInfoString);
    rs = pstmt.executeQuery();

    if (rs.next()) {
        orgInfoObj.put("orgName", rs.getString("orgName"));
    }

    rs.close();
    pstmt.close();

    String cntOfDevicesQuery = "SELECT COUNT(devicesn) AS cntOfDevices FROM device_info WHERE owner = 22";
    pstmt = con.prepareStatement(cntOfDevicesQuery);
    rs = pstmt.executeQuery();

    if (rs.next()) {
        orgInfoObj.put("cntOfDevices", rs.getInt("cntOfDevices"));
    }

    rs.close();
    pstmt.close();


    String deviceQuery = "SELECT "+
                            "dsd.devicesn, "+
                            "ROUND(dsd.temperature) AS temperature, "+
                            "ROUND(dsd.humidity) AS humidity, "+
                            "ROUND(dsd.co2) AS co2, "+
                            "ROUND(dsd.tvoc) AS tvoc, "+
                            "ROUND(dsd.pm_2_5) AS pm_2_5, "+
                            "ROUND(dsd.pm_10) AS pm_10, "+
                            "ROUND(dsd.radon) AS radon, "+
                            "ROUND(dsd.co) AS co, "+
                            "ROUND(dsd.pm_1_0) AS pm_1_0, "+
                            "CONVERT_TZ(dsd.tm, 'UTC', 'Asia/Seoul') AS tm "+
                        "FROM device_sensor_data dsd "+
                        "JOIN device_info di ON dsd.devicesn = di.devicesn "+
                        "JOIN ( "+
                            "SELECT devicesn, MAX(tm) AS latest_tm "+
                            "FROM device_sensor_data "+
                            "GROUP BY devicesn "+
                        ") AS latest_data ON dsd.devicesn = latest_data.devicesn AND dsd.tm = latest_data.latest_tm "+
                        "WHERE di.owner = 22";
    pstmt = con.prepareStatement(deviceQuery);
    rs = pstmt.executeQuery();

    while (rs.next()) {
        JSONObject deviceObj = new JSONObject();
        deviceObj.put("devicesn", rs.getString("devicesn"));
        deviceObj.put("tvoc", rs.getInt("tvoc"));
        deviceObj.put("co2", rs.getInt("co2"));
        deviceObj.put("pm_2_5", rs.getInt("pm_2_5"));
        deviceObj.put("pm_10", rs.getInt("pm_10"));
        deviceObj.put("temperature", rs.getInt("temperature"));
        deviceObj.put("humidity", rs.getInt("humidity"));
        devicesArray.add(deviceObj);
    }

    rs.close();
    pstmt.close();

    // JSON 구조에 추가
    orgInfoObj.put("devices", devicesArray);
    responseObj.put("orgInfo", orgInfoObj);

    // 결과 출력
    out.print(responseObj.toString());
%>

<%@ include file="./common/dbclose.jsp" %>
