<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<% String id = request.getParameter("id"); %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ecover</title>

    <link rel="stylesheet" href="asset/css/nomalize.css" />
    <link rel="stylesheet" href="asset/css/common.css" />
    <link rel="stylesheet" href="asset/css/customizing.css" />

    <script src="https://code.jquery.com/jquery-3.4.1.js"></script>

</head>

<body>
    <!-- 250204: Sensoring and Information -->
    <div class="container">
        <!-- 2025.02.03:  Naming Group and label company logo -->
        <div class="d-flex mb-36x">
            <div class="fs-50x bold">
                <span id="orgName"></span>
            </div>
            <i class="f-logo"></i>
        </div>

        <!-- 2025.02.03: Writing mention, Timing -->
        <div class="d-flex">
            <div class="fs-50x">
                <span id="mention">실시간 공기질 정화중입니다</span>
            </div>
            <div class="fs-35x">
                <span id="now">2025년 02월 03일 09시</span> <span> 기준</span>
            </div>
        </div>

        <!-- 250207: 강의실 마다 실시간 공기질 표기 / 캐러셀 추가 -->
        <div id="carouselExampleAutoplaying" class="carousel slide" data-bs-ride="carousel">
            <div class="carousel-inner" id="carouselContent"></div>
            <!-- <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleAutoplaying" data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleAutoplaying" data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Next</span>
            </button> -->
        </div>

</body>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script>
$(document).ready(function () {
    /**
     * api 를 통해 공기청정기 정보를 가져와야함
     */

    function main() {
        getValues().then(data => {
            const orgInfo = data.orgInfo;
            const devices = data.orgInfo.devices;
    
            getOrgInfo(orgInfo); // orgInfo 설정
            generateBoxes(orgInfo.cntOfDevices, devices); // 박스 생성
            setInterval(main, 20000); // 2분마다 실행 (20000ms)
        }).catch(error => {
            alert(error);  // 오류 발생 시 경고 메시지 출력
        });

        // const data = getValues(); //api에서 데이터를 가지고 옴
        // const orgInfo = data.orgInfo;
        // const devices = data.orgInfo.devices;

        // getOrgInfo(orgInfo); //orgInfo 설정
        // generateBoxes(orgInfo.cntOfDevices, devices); //박스 생성
        // setInterval(main, 20000); // 2분마다 실행 (20000ms)
    }
function updateTime() {
        const now = new Date();

        // KST 기준으로 변환
        const kst = new Date(now.getTime() + (9 * 60 * 60 * 1000));

        const year = kst.getUTCFullYear();
        const month = String(kst.getUTCMonth() + 1).padStart(2, '0'); // 월은 0부터 시작하므로 +1
        const date = String(kst.getUTCDate()).padStart(2, '0');
        const hours = String(kst.getUTCHours()).padStart(2, '0');
        const minutes = String(kst.getUTCMinutes()).padStart(2, '0');

            const formattedTime = year+'년 '+month+'월 '+date+'일 '+hours+'시 '+minutes+'분';


        // 시간 표시를 업데이트할 DOM 요소
        document.getElementById('now').textContent = formattedTime;
 }

    document.addEventListener("DOMContentLoaded", () => {
        populateCarousel();
    });

    function getValues() {
        return new Promise((resolve, reject) => {
            $.ajax({
                    url: "../get.jsp?id="+ '<%=id%>', // 실제 JSP 파일 경로로 수정하세요
		method: "GET",
                async: false,
                dataType: "json", // JSON 형식으로 응답 받기
                success: function(response) {
                    resolve(response);  // 응답 데이터를 Promise로 전달
                },
                error: function(xhr, status, error) {
                    reject(error);  // 오류 발생 시 Promise 거부
                }
            });
        });

    }

        function getPmColor(value) {
            if (value >= 0 && value <=15 ) return "sensor-status-01"; //좋음
            if (value > 15 && value <=35 ) return "sensor-status-02"; //보통
            if (value > 36 && value <=50 ) return "sensor-status-03"; //나쁨
            if (value > 51) return "sensor-status-04"; //매우나쁨
        }

        function getTVOCClass(value) {
            if (value >= 0 && value <=500 ) return "sensor-status-01";  // 안전
            if (value > 500 && value <=1000) return "sensor-status-02";  // 주의
            if (value > 1000 && value <=3000) return "sensor-status-03"; // 경고
            if (value > 3000) return "sensor-status-04"; // 경고

        }

        function getCO2Class(value) {
            if (value >= 0 && value <=450) return "sensor-status-01";  // 매우 좋음
            if (value > 450 && value <=1000) return "sensor-status-02"; // 좋음
            if (value > 1000 && value <=2000) return "sensor-status-03"; // 보통
            if (value > 2000) return "sensor-status-04"; // 나쁨
        }


    function getOrgInfo(orgInfo) {
        $("#orgName").text(orgInfo.orgName);
        $("#deviceCount").text("Total Devices: " + orgInfo.cntOfDevices);
    }

    function escapeHtml(text) {
        return text.replace(/[&<>"']/g, function(match) {
            const escape = {
                "&": "&amp;",
                "<": "&lt;",
                ">": "&gt;",
                '"': "&quot;",
                "'": "&#x27;"
            };
            return escape[match];
        });
    }
    


    function generateBoxes(cntOfDevices, devices) {
        const $carouselContent = $("#carouselContent");
        $carouselContent.empty(); // 기존 박스 삭제

        for (let index = 0; index < devices.length; index++) {
            var device = devices[index];
            var isActive = "";
            if(index == 0){
                isActive = "active";
            }
            var pm2_5Class = getPmColor(device.pm_2_5);
            var pm10Class = getPmColor(device.pm_10);
            var tvocClass = getTVOCClass(device.tvoc);
            var co2Class = getCO2Class(device.co2);


            var sensorBoxHTML = '<div class="carousel-item ' + isActive + '" data-bs-interval="5000">' +
            '<div class="sensor_box">' +
                '<figure class="figure">' +
                    '<div class="outercircle pm  '+ pm2_5Class +'">' +
                        '<div class="innercircle details">' +
                            '<p class="bold" id="pm2d5">' + device.pm_2_5 + '</p>' +
                            '<span class="unit">㎍/㎥</span>' +
                        '</div>' +
                    '</div>' +
                    '<figcaption class="fs-35x bold">초미세먼지</figcaption>' +
                '</figure>' +
                '<figure class="figure">' +
                    '<div class="outercircle pm '+ pm10Class + '">' +
                        '<div class="innercircle details">' +
                            '<p class="bold" id="pm10">' + device.pm_10 + '</p>' +
                            '<span class="unit">㎍/㎥</span>' +
                        '</div>' +
                    '</div>' +
                    '<figcaption class="fs-35x bold">미세먼지</figcaption>' +
                '</figure>' +
                '<figure class="figure">' +
                    '<div class="outercircle tvoc_con  '+ tvocClass + '">' +
                        '<div class="innercircle details">' +
                            '<p class="bold" id="tvoc_con">' + device.tvoc + '</p>' +
                            '<span class="unit">㎍/㎥</span>' +
                        '</div>' +
                    '</div>' +
                    '<figcaption class="fs-35x bold">가스</figcaption>' +
                '</figure>' +
                '<figure class="figure">' +
                    '<div class="outercircle co2  '+co2Class+'">' +
                        '<div class="innercircle details">' +
                            '<p class="bold" id="co2">' + device.co2 + '</p>' +
                            '<span class="unit">ppm</span>' +
                        '</div>' +
                    '</div>' +
                    '<figcaption class="fs-35x bold">이산화탄소</figcaption>' +
                '</figure>' +
                '<figure class="figure">' +
                    '<div class="outercircle temperature">' +
                        '<div class="innercircle details">' +
                            '<p class="bold" id="temperature">' + device.temperature + '</p>' +
                            '<span class="unit">°C</span>' +
                        '</div>' +
                    '</div>' +
                    '<figcaption class="fs-35x bold">온도</figcaption>' +
                '</figure>' +
                '<figure class="figure">' +
                    '<div class="outercircle humidity">' +
                        '<div class="innercircle details">' +
                            '<p class="bold" id="humidity">' + device.humidity + '</p>' +
                            '<span class="unit">%</span>' +
                        '</div>' +
                    '</div>' +
                    '<figcaption class="fs-35x bold">습도</figcaption>' +
                '</figure>' +
            '</div>' +
            '<div>' +
                '<h2 class="fs-50x bold devicesn">' + device.devicesn + '</h2>' +
            '</div>' +
        '</div>';
        
            $carouselContent.append(sensorBoxHTML);
        }
    }
    init();
	
    
    function  init() {
        main();
        updateTime();
    setInterval(updateTime, 60000); // 1분마다 업데이트
	}
});

</script>


</html>
