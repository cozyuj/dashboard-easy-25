$(document).ready(function () {
    /**
     * api 를 통해 공기청정기 정보를 가져와야함
     */

    function init() {
        main();
    }

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

    document.addEventListener("DOMContentLoaded", () => {
        populateCarousel();
    });

    function getValues() {
        return new Promise((resolve, reject) => {
            $.ajax({
                url: "../../../get.jsp", // 실제 JSP 파일 경로로 수정하세요
                method: "GET",
                async: false,
		 headers: {
        		'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
    		},
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

    function getColor(value) {
        if (value < 10) return "#2E59C4";
        if (value < 30) return "#2AB56E";
        if (value < 60) return "#F5C931";
        if (value < 90) return "#DA3539";
        return "#666666";
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

            var sensorBoxHTML = '<div class="carousel-item ' + isActive + '" data-bs-interval="2000">' +
            '<div class="sensor_box">' +
                '<figure class="figure">' +
                    '<div class="outercircle pm sensor-status-01">' +
                        '<div class="innercircle details">' +
                            '<p class="bold" id="pm2d5">' + device.pm_2_5 + '</p>' +
                            '<span class="unit">㎍/㎥</span>' +
                        '</div>' +
                    '</div>' +
                    '<figcaption class="fs-35x bold">초미세먼지</figcaption>' +
                '</figure>' +
                '<figure class="figure">' +
                    '<div class="outercircle pm sensor-status-01">' +
                        '<div class="innercircle details">' +
                            '<p class="bold" id="pm10">' + device.pm_10 + '</p>' +
                            '<span class="unit">㎍/㎥</span>' +
                        '</div>' +
                    '</div>' +
                    '<figcaption class="fs-35x bold">미세먼지</figcaption>' +
                '</figure>' +
                '<figure class="figure">' +
                    '<div class="outercircle tvoc_con sensor-status-03">' +
                        '<div class="innercircle details">' +
                            '<p class="bold" id="tvoc_con">' + device.tvoc + '</p>' +
                            '<span class="unit">㎍/㎥</span>' +
                        '</div>' +
                    '</div>' +
                    '<figcaption class="fs-35x bold">가스</figcaption>' +
                '</figure>' +
                '<figure class="figure">' +
                    '<div class="outercircle co2 sensor-status-02">' +
                        '<div class="innercircle details">' +
                            '<p class="bold" id="co2">' + device.co2 + '</p>' +
                            '<span class="unit">ppm</span>' +
                        '</div>' +
                    '</div>' +
                    '<figcaption class="fs-35x bold">이산화탄소</figcaption>' +
                '</figure>' +
                '<figure class="figure">' +
                    '<div class="outercircle co2 sensor-status-02">' +
                        '<div class="innercircle details">' +
                            '<p class="bold" id="temperature">' + device.temperature + '</p>' +
                            '<span class="unit">°C</span>' +
                        '</div>' +
                    '</div>' +
                    '<figcaption class="fs-35x bold">온도</figcaption>' +
                '</figure>' +
                '<figure class="figure">' +
                    '<div class="outercircle co2 sensor-status-02">' +
                        '<div class="innercircle details">' +
                            '<p class="bold" id="humidity">' + device.humidity + '</p>' +
                            '<span class="unit">' + device.humidity + '</span>' +
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

    updateTime();
    setInterval(updateTime, 60000); // 1분(60000ms)마다 실행

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
        console.log(formattedTime); 
        // 시간 표시를 업데이트할 DOM 요소
        document.getElementById('now').textContent = formattedTime;
    }


});
