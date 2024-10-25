select * 
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--Data selection
select Location, date, total_cases,new_cases,total_deaths, population
FROM PortfolioProject..CovidDeaths
order by 1,2

--Total cases v Total deaths
--shows likelihood of dying if contract covid in israel
select Location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathprecentage
FROM PortfolioProject..CovidDeaths
where location like '%israel%'
order by 1,2

--looking at total cases v population
--shows what precentage got covid 
select Location, date,population, total_cases,(total_cases/population)*100 as precentofpopulationinfected
FROM PortfolioProject..CovidDeaths
where location like '%israel%'
order by 1,2

--looking at highest infection rate
select Location,population, MAX(total_cases) as highestindectioncount,MAX((total_cases/population))*100 as precentofpopulationinfected
FROM PortfolioProject..CovidDeaths
--where location like '%israel%'
group by location, population
order by precentofpopulationinfected desc

--showing the countries with highest death count
select Location, max(cast(Total_deaths as int)) as Totaldeathcount
FROM PortfolioProject..CovidDeaths
--where location like '%israel%'
where continent is not null
group by location
order by Totaldeathcount desc

--BY Continent

--showing continents with highest death count
select continent, max(cast(Total_deaths as int)) as Totaldeathcount
FROM PortfolioProject..CovidDeaths
--where location like '%israel%'
where continent is not null
group by continent
order by Totaldeathcount desc

--GLOBAL NUMBERS

select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int))as total_deaths, SUM(cast(new_deaths as int))/ SUM(New_cases)*100 as Deathprecentage
FROM PortfolioProject..CovidDeaths
where continent is  not null
group by date 
order by 1,2

--looking at Total population vs vaccinations

select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int )) OVER (Partition by dea.location order by dea.location, dea.Date) as rollingpeoplevaccinated
--, (rollingpeoplevaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is  not null
order by 2,3

--USE CTE

with popvsvac (Continent, location, Date,population,new_vaccinations, rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int )) OVER (Partition by dea.location order by dea.location, dea.Date) as rollingpeoplevaccinated
--, (rollingpeoplevaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is  not null
--order by 2,3
)
select *, (rollingpeoplevaccinated/population) *100
from popvsvac

-- TEMP TABLE

DROP TABLE IF exists #PrecentPopulationVaccinated
CREATE TABLE #PrecentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
rollingpeoplevaccinated numeric
)

insert into #PrecentPopulationVaccinated
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int )) OVER (Partition by dea.location order by dea.location, dea.Date) as rollingpeoplevaccinated
--, (rollingpeoplevaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is  not null
order by 2,3

SELECT *, (rollingpeoplevaccinated/Population)*100
from #PrecentPopulationVaccinated



--Creating view for visualizations

CREATE VIEW PrecentPopulationVaccinated as
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int )) OVER (Partition by dea.location order by dea.location, dea.Date) as rollingpeoplevaccinated
--, (rollingpeoplevaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is  not null


SELECT * 
FROM PrecentPopulationVaccinated